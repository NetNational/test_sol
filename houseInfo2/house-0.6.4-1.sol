pragma solidity ^0.4.24;
// import './token.sol';
import './agreement.sol';
// import './register.sol';

interface ERC20Interface {
	// function transfer(address _to, uint256 _value) external;
	function transfer(address _to, uint256 _value) external  returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}
interface RegisterInterface {
	function isLogin(address _userAddr) external returns(bool);
}

contract RentBasic {
	enum HouseState {
		ReleaseRent,  
		WaitRent,  
		Renting,  
		EndRent,  
		Cance,  
		ReturnRent  
	}
	HouseState defaultState = HouseState.ReleaseRent;
	struct HouseInfo {			
			uint8    landRate; 
		    uint8    ratingIndex;  
		    uint8    huxing;     
			string   houseAddress; 		
			bytes32  houseId;   
			string   descibe;	
			string	 landlordInfo;  			
			string   hopeYou;  		
			address  landlord; 		
	}
	struct HouseReleaseInfo {
		HouseState    state;  
		uint32        tenancy;
		uint256       rent; 
		uint          releaseTime;  
		uint          updateTime; 
		uint          dealineTime;  
		bool          existed; 
	}
	// 租客对某一房源评价
	struct RemarkHouse {
		address tenant; // 租客地址	
		uint8   ratingIndex; // 评级级别
		string remarkLandlord; // 对房东评价
		uint256 operateTime; // 评论时间
	}
	// 房东对某一租客评价
	struct RemarkTenant {
		address leaser; // 房东
		uint8   ratingIndex; // 评价级别
		string  remarkTenant; // 对租客评价
		uint256 operateTime; // 评论时间
	}
	// RentToken token;
	ERC20Interface token;
	TenancyAgreement tenancyContract;
	RegisterInterface userRegister;
	HouseInfo public hsInformation;
	mapping(bytes32 => HouseInfo) houseInfos; 
	mapping(bytes32 => HouseReleaseInfo) hsReleaseInfos; 
	mapping(address => uint) public addrMoney; 
	mapping(bytes32 => RemarkHouse) public remarks; 
	mapping(bytes32 => RemarkTenant) public remarkTenants; 
	mapping(bytes32 => mapping(address => uint)) bonds; 
	mapping(address => address) l2rMaps;
	mapping(address => uint256) creditManager; 
	mapping(address => uint256) lockAmount;
	

	address public owner; 
	bool public flag;
	address public receiverPromiseMoney = 0x3c13520Bc27C8A38FD67533d02071e775da7b12F; 
	address public distributeRemarkAddr = 0xA4ef5514CCfe79B821a3F36A123e528e096cEa28; 
	address public saveTenanantAddr = 0xF87932Ee0e167f8B54209ca943af4Fad93B3B8A0; 
	address public punishAddr = 0x960bEDf8DF0A6e66B470ba560eE6fD1e0e32Ee23; 

	uint256 promiseAmount = 500 * (10 ** 8);
	uint256 punishLevel1Amount = 10 * (10 ** 8); 
	uint256 remarkAmount = 4 * (10 ** 8);

	event ReleaseInfo(bytes32 houseHash, HouseState _defaultState, uint32 _tenancy, uint256 _rent, uint _releaseTime, uint _deadTime, bool existed);	
	event ReleaseBasic(bytes32 houseHash, uint8 rating,string _houseAddr,uint8 _huxing,string _describe, string _info, string _hopeYou,address indexed _landlord);		
	event SignContract(address indexed _sender, bytes32 _houseId, uint256 _signHowLong, uint256 _rental, bytes32 _signatrue, uint256 _time);
	event CommentHouse(address indexed _commenter, uint8 _rating, string _ramark);
	event RequestSign(address indexed _sender, bytes32 _houseId,uint256 _realRent, address indexed saveTenanantAddr);
	event BreakContract(bytes32 _houseId, address indexed sender,string _reason,uint8 _punishLevel,uint256 uptime);
	event WithdrawDeposit(bytes32 _houseId,address indexed sender,uint256 amount,uint256 nowTime);
	// event RenterRaiseCrowding(address indexed _receiver, uint256 _fundingGoal, uint256 _durationInMinutes, address indexed _tokenContractAddress);
	
	constructor(address _token, address _register) {
		owner = msg.sender;
		token = ERC20Interface(_token);
		userRegister = RegisterInterface(_register);
	}

	modifier gtMinMoney(uint amount) {
		require(amount >= promiseAmount, "promise amount is not enough");
		_;
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
    // https://ethereum.stackexchange.com/questions/75849/ethereum-smart-contract-calling-a-function-in-another-smart-contract-that-has-a
	modifier onlyLogin() {
		require(userRegister.isLogin(msg.sender));
		_;
	}
	function releaseHouse(string _houseAddr,uint8 _huxing,string _describe, string _info, uint32 _tenancy, uint256 _rent, string _hopeYou) public onlyLogin returns (bytes32) {
		uint256 nowTimes = now; 
		uint256 deadTime = nowTimes + 7 days;
		address houseOwer = msg.sender;
		// releaser should hold not less than 500 BLT
		// token.transferFrom(houseOwer, receiverPromiseMoney, promiseAmount);
		require(token.transferFrom(houseOwer, receiverPromiseMoney, promiseAmount),"Release_Balance is not enough");
		addrMoney[houseOwer] = promiseAmount;
		bytes32 houseIds = keccak256(abi.encodePacked(houseOwer, nowTimes, deadTime));
		hsInformation = HouseInfo({				
			landRate: 2,		 
			ratingIndex: 2,
			huxing: _huxing,			
			hopeYou: _hopeYou,
			houseAddress: _houseAddr,			
			houseId: houseIds, 
			descibe: _describe,
			landlordInfo: _info,
			landlord: houseOwer			
		});
		houseInfos[houseIds] = hsInformation;
		hsReleaseInfos[houseIds] = HouseReleaseInfo({
			state: defaultState,
			tenancy: _tenancy,
			rent: _rent,
			releaseTime: nowTimes,
			updateTime: nowTimes,
			dealineTime: deadTime,
			existed: true
		});
		// releations[houseId].leaser = houseOwer;
		ReleaseBasic(houseIds, 2, _houseAddr, _huxing, _describe, _info, _hopeYou, houseOwer);
		ReleaseInfo(houseIds, defaultState, _tenancy,_rent,nowTimes,deadTime,true);
		return houseIds;
	}
	function deadReleaseHouse(bytes32 _houseId) returns(bool) {
		HouseReleaseInfo hsRelInfo = hsReleaseInfos[_houseId];
		if (now > hsRelInfo.dealineTime && hsRelInfo.state == HouseState.Renting) {
			hsReleaseInfos[_houseId].state = HouseState.Cance;
			return true;
		}
		return false;
	}
	function requestSign(bytes32 _houseId, uint256 _realRent) public onlyLogin returns (HouseState,address){
		HouseInfo hsInfo = houseInfos[_houseId];
		HouseReleaseInfo hsReInfo = hsReleaseInfos[_houseId];
		address sender = msg.sender;
		require(hsReInfo.existed, "House is not existed");
		require(hsReInfo.state == defaultState, "House State is not in release");
		// token.transferFrom(sender, saveTenanantAddr, _realRent);
		require(token.transferFrom(sender, saveTenanantAddr, _realRent), "Tenat's BLT not enough !");
		hsReleaseInfos[_houseId].state = HouseState.WaitRent;
		bonds[_houseId][msg.sender] = _realRent;
		// releations[_houseId].tenant = msg.sender;
		l2rMaps[hsInfo.landlord] = sender;
		RequestSign(sender, _houseId, _realRent, saveTenanantAddr);
		return (hsReInfo.state, hsInfo.landlord);
	}
	function signAgreement(bytes32 _houseId,string _name, uint _signHowLong,uint _rental, uint256 _yearRent) public onlyLogin returns (HouseState) {
		HouseInfo hsInfo = houseInfos[_houseId];
		HouseReleaseInfo hsReInfo = hsReleaseInfos[_houseId];
		require(hsReInfo.existed, "House is not existed");
		require(hsReInfo.state == HouseState.WaitRent, "House State is not in wait rent");
		uint256 nowTime = now;
		// pack message 
		bytes memory message = abi.encodePacked(sender, _houseId, _signHowLong, _rental, nowTime);
		
		bytes32 signatrue = keccak256(message);
		address sender = msg.sender;
		if (sender != hsInfo.landlord) {
			require(bonds[_houseId][sender] > 0, "Require the tenant have enough bond");
			token.transferFrom(sender, hsInfo.landlord, _rental);
// 			require(token.transferFrom(sender, hsInfo.landlord, _rental), "Tenat's BLT not enough !");
 			tenancyContract.tenantSign(_houseId, _name, _rental, _signHowLong, signatrue);
 			hsReleaseInfos[_houseId].state = HouseState.Renting;
		} else {
			tenancyContract = new TenancyAgreement(_name, _houseId, hsInfo.houseAddress, hsInfo.descibe, signatrue,_rental, _signHowLong);
		}
		// client start timer
		SignContract(sender, _houseId, _signHowLong, _rental, signatrue, nowTime);
		hsReleaseInfos[_houseId].updateTime = nowTime;
		return hsReInfo.state;
	}
	 function withdraw(bytes32 _houseId, uint amount) onlyLogin public returns(bool) {
	 	HouseInfo hs = houseInfos[_houseId];
	 	HouseReleaseInfo reInfo = hsReleaseInfos[_houseId];
	 	require(reInfo.existed, "Not find the house");
	 	require(reInfo.state == HouseState.EndRent || reInfo.state == HouseState.Cance, "House rent is not finished");
	 	require(amount > 0 , "Amount is error ");
	 	address sender = msg.sender;
	 	if (sender == hs.landlord) {
	 		require(addrMoney[msg.sender] > amount);
	 		// token.transferFrom(receiverPromiseMoney, sender, amount);
	 		require(token.transferFrom(receiverPromiseMoney, sender, amount), "withdraw error");
	 		addrMoney[msg.sender] = addrMoney[msg.sender] - amount; // decrease the landlord promise amount.
	 	} else {
	 		// Return the bond to the tenant
	 		require(bonds[_houseId][sender] >= amount);
		 	// token.transferFrom(saveTenanantAddr, sender, amount);
		 	require(token.transferFrom(saveTenanantAddr, sender, amount), "Transfer fail");
		 	bonds[_houseId][sender] = bonds[_houseId][sender] - amount;
	 	}
	 	uint256 nowTime = now;
	 	hsReleaseInfos[_houseId].updateTime = nowTime;
	 	WithdrawDeposit(_houseId, sender, amount, nowTime);
	 	return true;
	 }
	
	function getHouseBasicInfo(bytes32 _houseId) public returns(bytes32, uint8, string, uint8, string, 
		string, string, address) {
		HouseInfo houseInfo = houseInfos[_houseId];
		return (_houseId, houseInfo.ratingIndex, houseInfo.houseAddress, houseInfo.huxing,houseInfo.descibe,
			  houseInfo.landlordInfo,houseInfo.hopeYou, houseInfo.landlord);		
	}
	function getHouseReleaseInfo(bytes32 _houseId) public returns(HouseState, uint32, uint256, uint, uint, bool) {
		HouseReleaseInfo releaseInfo = hsReleaseInfos[_houseId];
		require(releaseInfo.existed, "Require the house is existed");
		return (releaseInfo.state, releaseInfo.tenancy, releaseInfo.rent, releaseInfo.releaseTime, releaseInfo.dealineTime, releaseInfo.existed);		
	}		
	function breakContract(bytes32 _houseId, string _reason, uint8 _punishLevel) public onlyLogin returns(bool) {
		HouseInfo hus = houseInfos[_houseId];
		HouseReleaseInfo relInfo = hsReleaseInfos[_houseId];
		require(relInfo.existed, "House is not existed");
		// If the house is in WaitRent, anyone can break the house normal
		if 	(relInfo.state == HouseState.WaitRent)	{
			hsReleaseInfos[_houseId].state = HouseState.Cance;
		}
		address sender = msg.sender;
		// If the house is in Renting, they punish one side
		if (relInfo.state != HouseState.ReleaseRent) {
		// 	// According the reason and punish level judge, lock the amount
		// 	// TODO this should be vote by owner
			uint256 amount = punishLevel1Amount;
			// uint256 amount = getPunishAmount(_punishLevel);
			if (sender == hus.landlord) {
				// token.transfer(sender, amount);
				require(token.transferFrom(receiverPromiseMoney, punishAddr, amount),"transfer fail");
				address another = l2rMaps[sender];
				bonds[_houseId][another] = bonds[_houseId][another] - amount;
			} else {
				// token.transfer(sender, amount);
				require(token.transferFrom(saveTenanantAddr, punishAddr, amount),"transfer fail");
			    addrMoney[hus.landlord] = addrMoney[hus.landlord] - amount;
			}		
			lockAmount[l2rMaps[sender]] = lockAmount[l2rMaps[sender]] + amount;
			hsReleaseInfos[_houseId].state = HouseState.Cance;
		}
		// Update releaseHouse information
		uint256 nowTime = now;
		hsReleaseInfos[_houseId].updateTime = nowTime;	
		BreakContract(_houseId, sender, _reason, _punishLevel, nowTime);
		return true;
	}
	function commentHouse(bytes32 _houseId, uint8 _ratingIndex, string _ramark) onlyLogin public returns(bool) {
		address sender = msg.sender;
		HouseReleaseInfo reInfo = hsReleaseInfos[_houseId];
		require(reInfo.existed, "Not find house");
	 	require(reInfo.state == HouseState.EndRent, "Rent is not finished");
		if (houseInfos[_houseId].landlord == sender) {
			remarks[_houseId] = RemarkHouse(sender, _ratingIndex, _ramark, now);
			creditManager[l2rMaps[sender]] += _ratingIndex; 
		} else {
			address landlord = houseInfos[_houseId].landlord;
			creditManager[landlord] += _ratingIndex;
			remarkTenants[_houseId] = RemarkTenant(sender, _ratingIndex, _ramark, now);
		}
		// token.transferFrom(distributeRemarkAddr,sender, remarkAmount);
		require(!token.transferFrom(distributeRemarkAddr,sender, remarkAmount), "Distribute fail !");
		CommentHouse(sender, _ratingIndex, _ramark);
		return true;
	}
}
