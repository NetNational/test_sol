pragma solidity ^0.4.24;
// import './agreement.sol';

interface TokenInterface {
	function transfer(address _to, uint256 _value) external  returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function isToken() pure returns(bool isIndeed);
}
interface RegisterInterface {
	function isLogin(address _userAddr) external returns(bool);
	function isRegister() public constant returns(bool isIndeed);
}
interface RemarkInterface {
	function isRemarkContract() public constant returns(bool isIndeed);
	function commentHouse(bytes32 _houseId, address _landlord, address _refeAddr, uint8 _ratingIndex, string _ramark) public returns(bool);
}
interface AuthInterface {
	function contrctExist() public constant returns(bool);
	function getHouseIds(address _addr) public constant returns(bytes32);
	function getIsAuth(address _addr) public constant returns(bool);
	function setIds(bytes32 _houseId, bytes32 _tranId, address _authAddr) returns(bool);
	function getTransIds(bytes32 _houseId) public constant returns(bytes32[]);
	function getLastTransId(bytes32 _houseId) public constant returns(bytes32);
	function cancleApprove(address _landlord, address _addr) public returns(bool);
}

contract RentBasic {
	enum HouseState {
		Release,  // 发布租赁中
		WaitRent,   // 租客交付定金后，请求租赁中
		Renting,  // 租赁中
		EndRent,   // 完成租赁
		Cance,   // 取消租赁
		InspcetBreak, // 毁约审核中
		BreakRent  // 解除租赁
	}
	HouseState defaultState = HouseState.Release;
	struct HouseInfo {			
			uint8    landRate; // 房东信用等级 1、信用非常好，2、信用良好，3、信用一般，4、信用差
		    uint8    ratingIndex;  // 评级指数
		    uint8    huxing;  // 户型（1/2/3居）		    
			string   houseAddress; // 房屋地址			
			bytes32  houseId;   // 房屋hash
			string   descibe;	// 房屋描述
			string	 landlordInfo; //房东情况 			
			string   hopeYou;  // 期待你的描述			
			address  landlord; // 房东地址		
	}
	struct HouseReleaseInfo {
		HouseState    state;   // 当前的状态
		uint32        tenancy; // 租期
		uint256       rent; // 租金
		uint          releaseTime;  // 发布时间
		uint          updateTime; // 更新时间
		uint          dealineTime;  // 截止时间
		bool          existed; // 该hash对应的House是否存在
		bool		  ischecked; // 毁约时是否通过管理员审核
		bool          canSign; // 能否签订合同
	}
	TokenInterface token;
	RegisterInterface userRegister;
	RemarkInterface remarkContract;
	AuthInterface authContract;
	mapping(bytes32 => HouseInfo) houseInfos; 
	mapping(bytes32 => HouseReleaseInfo) hsReleaseInfos; 
	mapping(address => uint) public addrMoney; 

	mapping(bytes32 => mapping(address => uint)) bonds; 
	mapping(address => address) l2rMaps;

	mapping(address => uint256) lockAmount;
	mapping(address => bool) addrs;

	address public owner; 

	address public recPromiseAddr = 0x8E0f4A1f3C0DBEA0C73684B49aE4AD02789B3EC4; 
	address public disRrkAddr = 0x16c0b9cb893BA4392131df01e70F831A07d02687; 
	address public saveTenanantAddr = 0x359Eab6d0F899Be438dEb2234c9389bAFc9A773d; 
	address public punishAddr = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB; 

	uint256 promiseAmount = 500 * (10 ** 8);
	uint256 punishLevel1Amount = 10 * (10 ** 8); 
	uint256 remarkAmount = 2 * (10 ** 8);

	event RelInfo(bytes32 houseHash, HouseState _defaultState, uint32 _tenancy, uint256 _rent, uint _releaseTime, uint _deadTime, bool existed);	
	event RelBasic(bytes32 houseHash, string _houseAddr,string _describe, string _info, string _hopeYou);		
	// event SignContract(address indexed _sender, bytes32 _houseId, uint256 _signHowLong, uint256 _rental, bytes32 _signatrue, uint256 _time);
	event SignContract(address indexed sender,bytes32 _houseId, address indexed _landlord, uint _signHowLong, uint _rental, uint nowTime);
	event CommentHouse(address indexed _commenter, bytes32 _houseId, uint8 _rating, string _ramark);
	event RequestSign(address indexed _sender, bytes32 _houseId,uint256 _realRent, address indexed saveTenanantAddr);
	event BreakContract(bytes32 _houseId, address indexed sender,string _reason, uint256 uptime);
	event WithdrawDeposit(bytes32 _houseId,address indexed sender,uint256 amount,uint256 nowTime);
	event ApprovalBreak(address indexed sender,bytes32 _houseId,address indexed _punishAddr,uint256 _punishAmount);
	event AuthEvent(uint _userId, address indexed caller, bytes32 _houseId);
	
	constructor(address _token, address _register, address _remarkAddr, address _authAddr) {
		owner = msg.sender;
		token = TokenInterface(_token);
		require(token.isToken());
		userRegister = RegisterInterface(_register);
		require(userRegister.isRegister());
		remarkContract = RemarkInterface(_remarkAddr);
		require(remarkContract.isRemarkContract(), "Remark Contract need import");
		authContract = AuthInterface(_authAddr);
		require(authContract.contrctExist());
		addrs[recPromiseAddr] = true;
		addrs[punishAddr] = true;
	}

    // https://ethereum.stackexchange.com/questions/75849/ethereum-smart-contract-calling-a-function-in-another-smart-contract-that-has-a
	modifier onlyLogin() {
		require(userRegister.isLogin(msg.sender), "require user must sign in!");
		_;
	}
	// 请求房屋
	modifier checkReq(bytes32 _houseId) {
		HouseInfo hsInfo = houseInfos[_houseId];
		HouseReleaseInfo hsReInfo = hsReleaseInfos[_houseId];
		require(hsReInfo.existed, "House is not existed");
		reqiure(hsInfo.landlord != msg.sender, "Cannt clinch a deal with yourself!");
		require(hsReInfo.state == defaultState, "House State is not in release");
		if (now > hsReInfo.dealineTime) {
			hsReleaseInfos[houseIds].state = HouseState.Cance; 
			revert("The released house has expired!");
		}
		_;
	}

	function isExist() public constant returns(bool isIndeed) {
        return true;
    }
	function releaseHouse(string _houseAddr,uint8 _huxing,string _describe, string _info, uint32 _tenancy, uint256 _rent, string _hopeYou) public onlyLogin returns (bytes32) {
		address houseOwer = msg.sender;
		require(authContract.getIsAuth(houseOwer), "House is not authenticated!");
		bytes32 authIds = authContract.getHouseIds(houseOwer);
		bytes32 lastId = authContract.getLastTransId(authIds);
		require(canState(hsReleaseInfos[lastId].state), "House is not allowed to re-publish now!"); // 房屋租赁中，暂不能发布房源
		uint256 nowTimes = now; 
		uint256 deadTime = nowTimes + 7 days;
		// 发布房源时生成的id
		bytes32 houseIds = keccak256(abi.encodePacked(houseOwer, authIds, lastId));
		// 将新的id添加到auth中
		authContract.setIds(authIds, houseIds, houseOwer);
		// releaser should hold not less than 500 BLT
		require(token.transferFrom(msg.sender, recPromiseAddr,  promiseAmount),"Release Balance is not enough");
		addrMoney[houseOwer] = promiseAmount;
		houseInfos[houseIds] = HouseInfo(2, 2, _huxing, _houseAddr, houseIds, _describe, _info, _hopeYou,houseOwer);
		hsReleaseInfos[houseIds] = HouseReleaseInfo(defaultState, _tenancy, _rent, nowTimes, nowTimes, deadTime, true, false, false);
		RelBasic(houseIds, _houseAddr, _describe, _info, _hopeYou);
		RelInfo(houseIds, defaultState, _tenancy, _rent, nowTimes, deadTime, true);
		return houseIds;
	}
	function canState(HouseState _state) returns (bool) {
		if (_state == HouseState.Renting || _state == HouseState.WaitRent || _state == HouseState.InspcetBreak) {
			return false;
		}
		return true;
	}
    // _deposit: 押金
	function requestSign(bytes32 _houseId, uint256 _realRent, uint256 _deposit) public onlyLogin checkReq(_houseId) returns (HouseState,address){
		address sender = msg.sender;
		require(token.transferFrom(sender, saveTenanantAddr, _deposit), "Tenat's BLT not enough !");
		hsReleaseInfos[_houseId].state = HouseState.WaitRent;
		bonds[_houseId][msg.sender] = _deposit; // 押金
		l2rMaps[houseInfos[_houseId].landlord] = sender;
		RequestSign(sender, _houseId, _realRent, saveTenanantAddr);
		return (HouseState.WaitRent, houseInfos[_houseId].landlord);
	}

	function signAgreement(bytes32 _houseId, address _landlord, address _leaserAddr, uint _signHowLong, uint _rental) public returns(bool) {
		require(hsReleaseInfos[_houseId].canSign, "The agreement cannt be signed!");
		HouseReleaseInfo hsReInfo = hsReleaseInfos[_houseId];
		hsReleaseInfos[_houseId].state = HouseState.Renting;
		uint256 nowTime = now;
		SignContract(msg.sender, _houseId, _landlord, _signHowLong, _rental, nowTime);
		hsReleaseInfos[_houseId].updateTime = nowTime;
		return true;
	}

	function withdraw(bytes32 _houseId, uint amount) onlyLogin public returns(bool) {
	 	HouseInfo hs = houseInfos[_houseId];
	 	HouseReleaseInfo reInfo = hsReleaseInfos[_houseId];
	 	require(reInfo.existed && reInfo.ischecked, "Not find the house or it has not checked!");
	 	require(reInfo.state == HouseState.EndRent || reInfo.state == HouseState.Cance, "House rent is not finished, if you want break the rent, please break contract first!");
	 	require(amount > 0 && addrMoney[msg.sender] >= amount, "Amount must greater than 0 and less than promise amount!");
	 	address sender = msg.sender;
	 	if (sender == hs.landlord) { 
	 		addrMoney[msg.sender] = addrMoney[msg.sender] - amount; // decrease the landlord promise amount.
	 		require(token.transferFrom(recPromiseAddr, sender, amount), "Withdraw error, from recPromiseAddr to landlord");
	 	} else {
	 		// Return the bond to the tenant
	 		require(bonds[_houseId][sender] >= amount);
	 		bonds[_houseId][sender] = bonds[_houseId][sender] - amount;
		 	require(token.transferFrom(saveTenanantAddr, sender, amount), "Transfer fail, from saveTenanantAddr to leaser");
	 	}
	 	hsReleaseInfos[_houseId].updateTime = now;
	 	WithdrawDeposit(_houseId, sender, amount, now);
	 	return true;
	 }
	
	function getHouseBasicInfo(bytes32 _houseId) public returns(bytes32, uint8, string, uint8, string, 
		string, string, address) {
		HouseInfo houseInfo = houseInfos[_houseId];
		return (_houseId, houseInfo.ratingIndex, houseInfo.houseAddress, houseInfo.huxing,houseInfo.descibe,
			  houseInfo.landlordInfo,houseInfo.hopeYou, houseInfo.landlord);		
	}
	function getHouseReleaseInfo(bytes32 _houseId) public returns(HouseState, uint32, uint256, uint, uint, bool) {
		HouseReleaseInfo RelInfo = hsReleaseInfos[_houseId];
		require(RelInfo.existed, "Require the house is existed !");
		return (RelInfo.state, RelInfo.tenancy, RelInfo.rent, RelInfo.releaseTime, RelInfo.dealineTime, RelInfo.existed);		
	}
	// 能否签约
	function canSign(bytes32 _houseId) public returns(bool) {
		HouseReleaseInfo RelInfo = hsReleaseInfos[_houseId];
		require(RelInfo.existed, "Require the house is existed !");
		return RelInfo.state == HouseState.WaitRent;		
	}
	function houseExist(bytes32 _houseId) public returns(bool) {
		if (hsReleaseInfos[_houseId].existed && hsReleaseInfos[_houseId].state == HouseState.WaitRent) {
			return true;
		}
		return false;
	}	
	function setSign(bytes32 _houseId)  returns(bool) {
		if (tx.origin != houseInfos[_houseId].landlord) {
			return false;
		}
		hsReleaseInfos[_houseId].canSign = true;
		return true;
	}
	function setHouseState(bytes32 _houseId) returns(bool) {
		address land = houseInfos[_houseId].landlord;
		if (tx.origin != land && tx.origin != l2rMaps[land]) {
			return false;
		}
		hsReleaseInfos[_houseId].state = HouseState.EndRent;
		hsReleaseInfos[_houseId].ischecked = true;
		authContract.cancleApprove(land, l2rMaps[land]);
		return true;
	}
	/*
	  @dev breakContract
	  @des this method call should be checked by admin, then it call be called.
	*/	
	function breakContract(bytes32 _houseId, string _reason) public onlyLogin returns(bool) {
		HouseInfo hus = houseInfos[_houseId];
		HouseReleaseInfo relInfo = hsReleaseInfos[_houseId];
		require(relInfo.state != HouseState.Cance || relInfo.state != HouseState.BreakRent,"Break Contract reqiure house not in cance or return rent status!");
		// If the house is in WaitRent, anyone can break the house normal
		address sender = msg.sender;	
		if (relInfo.state == HouseState.WaitRent || relInfo.state == defaultState) {
			hsReleaseInfos[_houseId].state = HouseState.Cance;
			hsReleaseInfos[_houseId].ischecked = true;
		} else {
			hsReleaseInfos[_houseId].state = HouseState.InspcetBreak;
		}
		// Update releaseHouse information
		hsReleaseInfos[_houseId].updateTime = now;	
		BreakContract(_houseId, sender, _reason, now);
		return true;
	}
	/*
 	* @dev checkBreak
 	* des: Admin judge punish one of the rent house. 
	*/
	function checkBreak(bytes32 _houseId, uint _punishAmount, address _punishAddr) public returns(bool){
		address sender = msg.sender;
        if (!addrs[sender]) {
        	return false;
        }
		HouseReleaseInfo relInfo = hsReleaseInfos[_houseId];
		require(relInfo.existed && _punishAmount >= 0, "House is not existed !");
		require(relInfo.state == HouseState.InspcetBreak, "House is not in inspect!");
		hsReleaseInfos[_houseId].ischecked = true;
		HouseInfo hus = houseInfos[_houseId];
		address sendAddr;
		if (_punishAddr == hus.landlord) { // 房东为被惩罚者，房东保证金扣除amount个，租客保证金加上amount个
			addrMoney[hus.landlord] = addrMoney[hus.landlord] - _punishAmount;
			bonds[_houseId][l2rMaps[hus.landlord]] = bonds[_houseId][l2rMaps[hus.landlord]] + _punishAmount;
			sendAddr = recPromiseAddr;
			authContract.cancleApprove(_punishAddr, l2rMaps[_punishAddr]);
		} else if (_punishAddr == l2rMaps[hus.landlord]) { // 租户是被惩罚者
			bonds[_houseId][_punishAddr] = bonds[_houseId][_punishAddr] - _punishAmount;
			addrMoney[hus.landlord] = addrMoney[hus.landlord] + _punishAmount;
			sendAddr = saveTenanantAddr;
			authContract.cancleApprove(hus.landlord, _punishAddr);
		}
		hsReleaseInfos[_houseId].state = HouseState.BreakRent;
		require(token.transferFrom(sendAddr, punishAddr, _punishAmount), "transfer fail, please approve the transfer from the sendAddr to punishAddr!");
		ApprovalBreak(sender, _houseId, _punishAddr, _punishAmount);
		return true;
	}
    // 更新审核员地址
	function updateAuditor(address _addr, bool _flag) public returns(bool) {
		require(msg.sender == owner, "check break address must update by the onwer");
		addrs[_addr] = _flag;
		return true;
	}

	function commentHouse(bytes32 _houseId, uint8 _ratingIndex, string _ramark) public returns(bool) {
		address sender = msg.sender;
		HouseReleaseInfo reInfo = hsReleaseInfos[_houseId];
		require(reInfo.ischecked, "Not finish the transaction!");
	 	address _refeAddr;
	 	address landlord = houseInfos[_houseId].landlord;
	 	if (landlord == sender) {  // 房东
	 		_refeAddr = l2rMaps[sender];
	 	} else {
	 		_refeAddr = landlord;
	 	}
	 	bool flag = remarkContract.commentHouse(_houseId, landlord, _refeAddr, _ratingIndex, _ramark);
	 	if (!flag) {
	 		return false;
	 	}
		require(token.transferFrom(disRrkAddr, sender, remarkAmount), "Distribute fail !");
		CommentHouse(sender, _houseId, _ratingIndex, _ramark);
		return true;
	}
}
