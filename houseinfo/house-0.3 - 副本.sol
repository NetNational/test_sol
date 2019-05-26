pragma solidity ^0.4.24;

import '../../token/token.sol';

contract RentBasic {

	enum HouseState {
		ReleaseRent,  // 发布租赁
		Renting,  // 租赁中
		EndRent,   // 完成租赁
		Cance,   // 取消租赁
		ReturnRent  // 退回租赁(当超出dealine时仍未租出)
	}

	HouseState defaultState = HouseState.ReleaseRent;
	// 房源基本信息
	struct HouseInfo {			
			uint8    landRate; // 房东信用等级 1、信用非常好，2、信用良好，3、信用一般，4、信用差
		    uint8   ratingIndex;  // 评级指数
		    uint8   huxing;  // 户型（1/2/3居）		    
			string   houseAddress; // 房屋地址			
			bytes32   houseId;   // 房屋hash
			bytes32   descibe;	// 房屋描述
			bytes32	 landlordInfo; //房东情况 			
			bytes32   hopeYou;  // 期待你的描述			
			address  landlord; // 房东地址			
	}
	// 房源发布信息
	struct HouseReleaseInfo {
		HouseState    state;   // 当前的状态
		uint32   tenancy; // 租期
		uint256   rent; // 租金
		uint   releaseTime;  // 发布时间
		uint   updateTime; // 更新时间
		uint   dealineTime;  // 截止时间
		bool     existed; // 该hash对应的House是否存在
	}
	// 租客对某一房源评价
	struct RemarkHouse {
		address tenant; // 租客地址
		uint8   ratingIndex; // 评级级别
		bytes32 remarkLandlord; // 对房东评价
	}
	// 房东对某一租客评价
	struct RemarkTenant {
		address leaser; // 房东
		uint8   ratingIndex; // 评价级别
		bytes32 remarkTenant; // 对租客评价
	}

	RentToken token;
	// HouseInfo[] public houseInfos;
	HouseInfo hsInformation;
	HouseReleaseInfo hsReleaseInfo;
	mapping(bytes32 => HouseInfo) houseInfos;  // 房源基本信息映射
	mapping(bytes32 => HouseReleaseInfo) hsReleaseInfos; // 房源发布信息映射
	mapping(address => uint) addrMoney;  // 用户对应地址所交保证金
	mapping(bytes32 => RemarkHouse) remarks; // 租客对房子以房东的评价
	mapping(bytes32 => RemarkTenant) remarkTenants; // 房东对租客评价的集合
	
	address public owner; // 合约发布者

	address public receiverPromiseMoney = 0x3c13520Bc27C8A38FD67533d02071e775da7b12F; // 接收房东交保证金地址
	address public distributeRemarkAddr = 0xA4ef5514CCfe79B821a3F36A123e528e096cEa28; // 发放奖励的地址

	uint256 public punishAmount = 5 * (10 ** 8); // 惩罚扣除
	uint256 public remarkAmount = 2 * (10 ** 8); // 奖励数量

	event ReleaseInfo(bytes32 houseHash, HouseState defaultState, uint32 _tenancy, uint256 _rent, uint _releaseTime, uint _deadTime, bool existed);	
	event ReleaseHouseBasicInfo(bytes32 houseHash, uint8 rating,string _houseAddr,uint8 _huxing,bytes32 _describe, bytes32 _info, bytes32 _hopeYou,address indexed _landlord);		
	event SignContract(address indexed _sender, bytes32 _houseId, uint256 _signHowLong, uint256 _rental, bytes32 _signatrue, uint256 _time);
	event CommentHouse(address indexed _commenter, uint8 _rating, bytes32 _ramark);
	// event RenterRaiseCrowding(address indexed _receiver, uint256 _fundingGoal, uint256 _durationInMinutes, address indexed _tokenContractAddress);
	
	function constructor() {
		owner = msg.sender;
		token = RentToken(msg.sender);
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
	function releaseHouse(string _houseAddr,uint8 _huxing,bytes32 _describe, bytes32 _info, uint32 _tenancy, uint256 _rent, bytes32 _hopeYou) public returns (bool) {
		uint256 nowTimes = now; 
		uint256 deadTime = nowTimes + 7 days;
		defaultState = HouseState.Renting;
		address houseOwer = msg.sender;
		// releaser should hold not less than 500 BLT
		require(token.transferFrom(houseOwer, receiverPromiseMoney, promiseAmount) == true, "Please promise enough money, which is not less than 500 BLT!");
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
		hsReleaseInfo = HouseReleaseInfo({
			state: defaultState,
			tenancy: _tenancy,
			rent: _rent,
			releaseTime: nowTimes,
			updateTime: nowTimes,
			dealineTime: deadTime,
			existed: true
		});
		houseInfos[houseIds] = hsInformation;
		hsReleaseInfos[houseIds] = hsReleaseInfo;
		ReleaseHouseBasicInfo(houseIds, 2, _houseAddr, _huxing, _describe, _info, _hopeYou, houseOwer);
		ReleaseInfo(houseIds, defaultState, _tenancy,_rent,nowTimes,deadTime,true);
		// PulishMessage(_landlord, houseInfo, houseIds);
	}

	/**
	 * title signContract
	 * @dev  _renter and _leaser sign how long agreement. It may be also including approve, send key
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , signHowLong: how long of the agreement}
	 */
	function signContract(bytes32 _houseId, uint _signHowLong, uint _rental) public returns (bool) {
		HouseInfo hsInfo = houseInfos[_houseId];
		HouseReleaseInfo hsReInfo = hsReleaseInfos[_houseId];
		require(!hsReInfo.existed, "House is not existed");
		require(hsReInfo.state == HouseState.Renting, "House State is not right");
		uint256 nowTime = now;
		address sender = msg.sender;
		if (sender != hsInfo.landlord) {
			require(token.transferFrom(sender, hsInfo.landlord, _rental) == true, "Tenat's BLT not enough !");
		} 
		// pack message 
		bytes memory message = abi.encodePacked(sender, _houseId, _signHowLong, _rental, nowTime);
		// sign the message
		bytes32 signatrue = keccak256(message);
		// client start timer
		SignContract(sender, _houseId, _signHowLong, _rental, signatrue, nowTime);
		hsReleaseInfos[_houseId].updateTime = nowTime;
	}
	/**
	 * title signContract
	 * dev  _renter and _leaser sign how long agreement. It may be also including approve, send key
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , signHowLong: how long of the agreement}
	 */
	 function withdrawPromise(bytes32 _houseId) {
	 	HouseInfo hs = houseInfos[_houseId];
	 	HouseReleaseInfo reInfo = hsReleaseInfos[_houseId];
	 	require(!reInfo.existed, "Not find the house");
	 	require(reInfo.state == HouseState.EndRent, "House rent is not finished");
	 	require(addrMoney[msg.sender] == promiseAmount, "Amount is not same");
	 	token.transfer(receiverPromiseMoney, addrMoney[msg.sender]);
	 	uint256 nowTime = now;
	 	hsReleaseInfos[_houseId].updateTime = nowTime;
	 }
	/**
	 * title getHouseInfo
	 * dev get release rent house information
	 * Parm {_index: the house informaion position}
	 */
	function getHouseBasicInfo(bytes32 _houseId) public returns(bytes32, uint8, string, uint8, bytes32, 
		bytes32, bytes32, address) {

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
		require(!releaseInfo.existed, "Require the house is existed");
		return (releaseInfo.state, releaseInfo.tenancy, releaseInfo.rent, releaseInfo.releaseTime, releaseInfo.dealineTime, releaseInfo.existed);		
	}		
	
	/**
	 * title breakContract
	 * dev  who break the contract and how to record it. And it will run by the contract or anyone call it
	 * Parm {}
	 * TODO punishAmount
	 */
	function breakContract(bytes32 _houseId, string _reason) public returns (uint256 money) {
		HouseReleaseInfo relInfo = hsReleaseInfos[_houseId];
		require(!relInfo.existed, "Require the house is existed");
		hsReleaseInfos[_houseId].state = HouseState.EndRent;
		hsReleaseInfos[_houseId].updateTime = now;
		if (relInfo.landlord == msg.sender) {
			addrMoney[msg.sender] = addrMoney[msg.sender] - punishAmount;
		}	
	}
	/**
	 * title commentHouse
	 * dev 
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , _lockKey: the key of the door}
	 */
	function commentHouse(bytes32 _houseId, uint8 _ratingIndex) {
		address sender = msg.sender;
		if (houseInfos[_houseId].landlord == sender) {
			require(token.transfer(receiverPromiseMoney, addrMoney[msg.sender]));
		} else {

		}
		CommentHouse(address indexed _commenter, uint8 _rating, bytes32 _ramark)
	}
	/**
	 * title sendKey
	 * dev _leaser send the key to _renter
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , _lockKey: the key of the door}
	 */
	function sendKey(address _leaser, address _renter, address _lockKey) public returns (bool) {

	}
	/**
	 * title raisePromiseMoney
	 * dev _renter and _leaser should raise a amount of the token as a promise
	 * Parm {_addr: the address of the raise promise money, _lock_key：the key of the door , _value: the cash deposit}
	 */
	function raisePromiseMoney(uint _amount) public gtMinMoney(_amount) {
		address addr = msg.sender;
		// transfer(msg.sender, _amount);
	}
	/**
	 * title setPromiseMoney
	 * dev _leaser send the key to _renter
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , _lockKey: the key of the door}
	 */
	function setPromiseMoney(uint256 _promiseAmount) public onlyOwner {
		promiseAmount = _promiseAmount;
	}

	function getPromiseMoney() public returns(uint256) {
		return promiseAmount;
	}

}
