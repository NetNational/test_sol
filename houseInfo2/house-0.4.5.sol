pragma solidity ^0.4.24;
import './token.sol';
import './agreement.sol';

contract RentBasic {
	enum HouseState {
		ReleaseRent,  // 发布租赁中
		WaitRent,   // 租客交付定金后，请求租赁中
		Renting,  // 租赁中
		EndRent,   // 完成租赁
		Cance,   // 取消租赁
		ReturnRent  // 退回租赁(当超出dealine时仍未租出)
	}

	HouseState defaultState = HouseState.ReleaseRent;
	// 房源基本信息
	struct HouseInfo {			
			uint8    landRate; // 房东信用等级 1、信用非常好，2、信用良好，3、信用一般，4、信用差
		    uint8    ratingIndex;  // 评级指数
		    uint8    huxing;  // 户型（1/2/3居）		    
			string   houseAddress; // 房屋地址			
			bytes32  houseId;   // 房屋hash
			string  descibe;	// 房屋描述
			string	 landlordInfo; //房东情况 			
			string  hopeYou;  // 期待你的描述			
			address  landlord; // 房东地址			
	}
	// 房源发布信息
	struct HouseReleaseInfo {
		HouseState    state;   // 当前的状态
		uint32        tenancy; // 租期
		uint256       rent; // 租金
		uint          releaseTime;  // 发布时间
		uint          updateTime; // 更新时间
		uint          dealineTime;  // 截止时间
		bool          existed; // 该hash对应的House是否存在
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
		string remarkTenant; // 对租客评价
		uint256 operateTime; // 评论时间
	}

	RentToken token;
	TenancyAgreement tenancyContract;
	HouseInfo public hsInformation;
	mapping(bytes32 => HouseInfo) public houseInfos;  // 房源基本信息映射
	mapping(bytes32 => HouseReleaseInfo) public hsReleaseInfos; // 房源发布信息映射
	mapping(address => uint) public addrMoney;  // 用户对应地址所交保证金
	mapping(bytes32 => RemarkHouse) public remarks; // 租客对房子以房东的评价
	mapping(bytes32 => RemarkTenant) public remarkTenants; // 房东对租客评价的集合
	mapping(bytes32 => mapping(address => uint)) bonds; // 租客对某一房子所交保证金
	mapping(address => address) l2rMaps; // 房东与租客的映射
	mapping(address => uint256) creditManager; // 信用等级管理 
	mapping(address => uint256) lockAmount; // 毁约时冻结某个账户的金额
	

	address public owner; // 合约发布者
	
	address public receiverPromiseMoney = 0x3c13520Bc27C8A38FD67533d02071e775da7b12F; // 接收房东交保证金地址
	address public distributeRemarkAddr = 0xA4ef5514CCfe79B821a3F36A123e528e096cEa28; // 发放奖励的地址
	address public saveTenanantAddr = 0xF87932Ee0e167f8B54209ca943af4Fad93B3B8A0; // 存放租客保证金的地址
	address public punishAddr = 0x960bEDf8DF0A6e66B470ba560eE6fD1e0e32Ee23; // 保存惩罚锁定奖励地址

	uint256 promiseAmount = 500 * (10 ** 8); // 保证金
	uint256 punishLevel1Amount = 10 * (10 ** 8); // 惩罚扣除
	uint256 remarkAmount = 4 * (10 ** 8); // 奖励数量

	event ReleaseInfo(bytes32 houseHash, HouseState _defaultState, uint32 _tenancy, uint256 _rent, uint _releaseTime, uint _deadTime, bool existed);	
	event ReleaseBasic(bytes32 houseHash, uint8 rating,string _houseAddr,uint8 _huxing,string _describe, string _info, string _hopeYou,address indexed _landlord);		
	event SignContract(address indexed _sender, bytes32 _houseId, uint256 _signHowLong, uint256 _rental, bytes32 _signatrue, uint256 _time);
	event CommentHouse(address indexed _commenter, uint8 _rating, string _ramark);
	event RequestSign(address indexed _sender, bytes32 _houseId,uint256 _realRent, address indexed saveTenanantAddr);
	event BreakContract(bytes32 _houseId, address indexed sender,string _reason,uint8 _punishLevel,uint256 uptime);
	event WithdrawDeposit(bytes32 _houseId,address indexed sender,uint256 amount,uint256 nowTime);
	// event RenterRaiseCrowding(address indexed _receiver, uint256 _fundingGoal, uint256 _durationInMinutes, address indexed _tokenContractAddress);
	
	constructor(ERC20Interface _token) {
		owner = msg.sender;
		token = RentToken(_token);
	}

	modifier gtMinMoney(uint amount) {
		require(amount >= promiseAmount, "promise amount is not enough");
		_;
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/**
	 * title lease
	 * dev leaser rent out the house
	 * Parm {_leaser: the address of the leaser, _lockKey：the key of the door , _value: the cash deposit}
	 */
	function releaseHouse(string _houseAddr,uint8 _huxing,string _describe, string _info, uint32 _tenancy, uint256 _rent, string _hopeYou) public returns (bytes32) {
		uint256 nowTimes = now; 
		uint256 deadTime = nowTimes + 7 days;
		address houseOwer = msg.sender;
		// releaser should hold not less than 500 BLT
		require(token.transferFrom(houseOwer, receiverPromiseMoney, promiseAmount),"Release house fail! Balance is not enough");
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
	/*
	* title deadReleaseHouse
	* dev check whether the house alread dealine
	* Param:  {_houseId: house hash} 
	*/
	function deadReleaseHouse(bytes32 _houseId) returns(bool) {
		HouseReleaseInfo hsRelInfo = hsReleaseInfos[_houseId];
		if (now > hsRelInfo.dealineTime && hsRelInfo.state == HouseState.Renting) {
			hsReleaseInfos[_houseId].state = HouseState.Cance;
			return true;
		}
		return false;
	}
	/**
	 * title requestSign
	 * dev tenant request sign the agreement.
	 * Parm {_leaser: the address of the leaser, _rental: month rental, signHowLong: how long of the agreement}
	 */
	function requestSign(bytes32 _houseId, uint256 _realRent) public returns (HouseState,address){
		HouseInfo hsInfo = houseInfos[_houseId];
		HouseReleaseInfo hsReInfo = hsReleaseInfos[_houseId];
		address sender = msg.sender;
		require(hsReInfo.existed, "House is not existed");
		require(hsReInfo.state == defaultState, "House State is not in release");
		require(token.transferFrom(sender, saveTenanantAddr, _realRent), "Tenat's BLT not enough !");
		hsReleaseInfos[_houseId].state = HouseState.WaitRent;
		bonds[_houseId][msg.sender] = _realRent;
		// releations[_houseId].tenant = msg.sender;
		l2rMaps[hsInfo.landlord] = sender;
		RequestSign(sender, _houseId, _realRent, saveTenanantAddr);
		return (hsReInfo.state, hsInfo.landlord);
	}
	/**
	 * title signContract
	 * dev leaser sign the agreement.
	 * Parm {_leaser: the address of the leaser, _rental: month rental, signHowLong: how long of the agreement}
	 */
	function signAgreement(bytes32 _houseId,string _name, uint _signHowLong,uint _rental, uint256 _yearRent) public returns (HouseState) {
		HouseInfo hsInfo = houseInfos[_houseId];
		HouseReleaseInfo hsReInfo = hsReleaseInfos[_houseId];
		require(hsReInfo.existed, "House is not existed");
		require(hsReInfo.state == HouseState.WaitRent, "House State is not in wait rent");
		uint256 nowTime = now;
		// pack message 
		bytes memory message = abi.encodePacked(sender, _houseId, _signHowLong, _rental, nowTime);
		// sign the message
		bytes32 signatrue = keccak256(message);
		address sender = msg.sender;
		if (sender != hsInfo.landlord) {
			require(bonds[_houseId][sender] > 0, "Require the tenant have enough bond");
			require(token.transferFrom(sender, hsInfo.landlord, _rental), "Tenat's BLT not enough !");
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
	/**
	 * title withdraw
	 * dev  Withdraw the deposit to tenant and leaser
	 * Parm {_houseId: the id of hourse, amount: }
	 */
	 function withdraw(bytes32 _houseId, uint amount) {
	 	HouseInfo hs = houseInfos[_houseId];
	 	HouseReleaseInfo reInfo = hsReleaseInfos[_houseId];
	 	require(reInfo.existed, "Not find the house");
	 	require(reInfo.state == HouseState.EndRent || reInfo.state == HouseState.Cance, "House rent is not finished");
	 	require(amount > 0 , "Amount is error ");
	 	address sender = msg.sender;
	 	if (sender == hs.landlord) {
	 		require(addrMoney[msg.sender] > amount);
	 		require(token.transferFrom(receiverPromiseMoney, sender, amount), "withdraw error");
	 		addrMoney[msg.sender] = addrMoney[msg.sender] - amount; // decrease the landlord promise amount.
	 	} else {
	 		// Return the bond to the tenant
	 		require(bonds[_houseId][sender] >= amount, "Deposit amount is less than withdraw amount");
		 	require(token.transferFrom(saveTenanantAddr, sender, amount), "Transfer fail");
		 	bonds[_houseId][sender] = bonds[_houseId][sender] - amount;
	 	}
	 	uint256 nowTime = now;
	 	hsReleaseInfos[_houseId].updateTime = nowTime;
	 	WithdrawDeposit(_houseId, sender, amount, nowTime);
	 }
	/**
	 * title getHouseInfo
	 * dev get release rent house information
	 * Parm {_index: the house informaion position}
	 */
	function getHouseBasicInfo(bytes32 _houseId) public returns(bytes32, uint8, string, uint8, string, 
		string, string, address) {
		HouseInfo houseInfo = houseInfos[_houseId];
		return (_houseId, houseInfo.ratingIndex, houseInfo.houseAddress, houseInfo.huxing,houseInfo.descibe,
			  houseInfo.landlordInfo,houseInfo.hopeYou, houseInfo.landlord);		
	}
	/**
	 * title getHouseInfo
	 * dev get release rent house information
	 * Parm {_index: the house informaion position}
	 */
	function getHouseReleaseInfo(bytes32 _houseId) public returns(HouseState, uint32, uint256, uint, uint, bool) {
		HouseReleaseInfo releaseInfo = hsReleaseInfos[_houseId];
		require(releaseInfo.existed, "Require the house is existed");
		return (releaseInfo.state, releaseInfo.tenancy, releaseInfo.rent, releaseInfo.releaseTime, releaseInfo.dealineTime, releaseInfo.existed);		
	}		
	
	/**
	 * title breakContract
	 * dev  who break the contract and how to record it. And it will run by the contract or anyone call it
	 * Parm {_reason: why break the contract, _punishLevel: punish level, 0: not punish, 1: }
	 * TODO punishAmount
	 */
	function breakContract(bytes32 _houseId, string _reason, uint8 _punishLevel) public {
		HouseInfo hus = houseInfos[_houseId];
		HouseReleaseInfo relInfo = hsReleaseInfos[_houseId];
		require(relInfo.existed, "Require the house is existed");
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
				require(token.transfer(sender, amount), "Transfer fail");
				// require(token.transferFrom(receiverPromiseMoney, punishAddr, amount),"transfer fail");
				address another = l2rMaps[sender];
				bonds[_houseId][another] = bonds[_houseId][another] - amount;
			} else {
				require(token.transfer(sender, amount), "Transfer fail");
				// require(token.transferFrom(saveTenanantAddr, punishAddr, amount),"transfer fail");
			    addrMoney[hus.landlord] = addrMoney[hus.landlord] - amount;
			}		
			lockAmount[l2rMaps[sender]] = lockAmount[l2rMaps[sender]] + amount;
			hsReleaseInfos[_houseId].state = HouseState.Cance;
		}
		// Update releaseHouse information
		uint256 nowTime = now;
		hsReleaseInfos[_houseId].updateTime = nowTime;	
		BreakContract(_houseId, sender, _reason, _punishLevel, nowTime);
	}
	/**
	 * title commentHouse
	 * dev leaser and tenant comment echo other
	 * Parm {_houseId: the house hash, _ratingIndex: remarkable record (1-10) , _ramark: remark about the house or the tenant}
	 */
	function commentHouse(bytes32 _houseId, uint8 _ratingIndex, string _ramark) returns(bool) {
		address sender = msg.sender;
		HouseReleaseInfo reInfo = hsReleaseInfos[_houseId];
		require(reInfo.existed, "Not find the house");
	 	require(reInfo.state == HouseState.EndRent, "House rent is not finished");
		if (houseInfos[_houseId].landlord == sender) {
			remarks[_houseId] = RemarkHouse(sender, _ratingIndex, _ramark, now);
			creditManager[l2rMaps[sender]] += _ratingIndex; 
		} else {
			address landlord = houseInfos[_houseId].landlord;
			creditManager[landlord] += _ratingIndex;
			remarkTenants[_houseId] = RemarkTenant(sender, _ratingIndex, _ramark, now);
		}
		require(!token.transferFrom(distributeRemarkAddr,sender, remarkAmount), "Reward distribute fail !");
		CommentHouse(sender, _ratingIndex, _ramark);
		return true;
	}

}
