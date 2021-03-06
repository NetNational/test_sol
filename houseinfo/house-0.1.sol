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

	struct HouseInfo {
			HouseState    state;   // 当前的状态
			uint8    landRate; // 房东信用等级 1、信用非常好，2、信用良好，3、信用一般，4、信用差
		    uint8   ratingIndex;  // 评级指数
		    uint8   huxing;  // 户型（1/2/3居）
		    uint32   tenancy; // 租期
			uint32   rent; // 租金
			uint   releaseTime;  // 发布时间
			uint   updateTime; // 更新时间
			uint   dealineTime;  // 截止时间
			string   houseAddress; // 房屋地址			
			bytes32   houseId;   // 房屋hash
			bytes32   descibe;	// 房屋描述
			bytes32	 landlordInfo; //房东情况 			
			bytes32   hopeYou;  // 期待你的描述			
			address  landlord; // 房东地址
			bool     existed; // 该hash对应的House是否存在
	}

	RentToken token;
	// HouseInfo[] public houseInfos;
	HouseInfo hsInformation;
	mapping(bytes32 => HouseInfo) houseInfos;
	mapping(address => uint) addrMoney;  // 用户对应地址所交保证金

	uint 	public rent;	// 租金
	uint 	public house; 	// 房源
	address public landlord; // 房东地址 
	
	uint 	public createdTime; // 发布时间

	address public owner; // 合约发布者

	address public receiverPromiseMoney = 0x3c13520Bc27C8A38FD67533d02071e775da7b12F; // 接收房东交保证金地址
	uint256 public promiseAmount = 500;

	event PublishHouse(bytes32 houseIds, address indexed houseOwer);

	// event PulishMessage(address index _landlord, HouseInfo _baseInfo, bytes32 _houseIds);
	// event ReleaseHouseInfo(bytes32 houseHash, uint8 rating, HouseState defaultState,string _houseAddr,uint8 _huxing,bytes32 _describe, bytes32 _info, uint32 _tenancy, uint32 _rent, bytes32 _hopeYou, uint _releaseTime, uint _deadTime, address indexed _landlord,bool existed);

	// event SignContract(address indexed _landlord, address indexed _renter, uint256 _time);
	event SignContract(address indexed _sender, bytes32 _houseId, uint256 _signHowLong, uint256 _rental, bytes32 _signatrue, uint256 _time);

	event RenterRaiseCrowding(address indexed _receiver, uint256 _fundingGoal, uint256 _durationInMinutes, address indexed _tokenContractAddress);
	
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
	function releaseHouse(string _houseAddr,uint8 _huxing,bytes32 _describe, bytes32 _info, uint32 _tenancy, uint32 _rent, bytes32 _hopeYou) public returns (bool) {
		uint256 nowTimes = now; 
		uint256 deadTime = nowTimes + 7 days;
		defaultState = HouseState.Renting;
		address houseOwer = msg.sender;
		// releaser should hold not less than 500 BLT
		require(token.transferFrom(houseOwer, receiverPromiseMoney, promiseAmount) == true, "Please promise enough money, which is not less than 500 BLT!");
		addrMoney[houseOwer] = promiseAmount;
		bytes32 houseIds = keccak256(abi.encodePacked(houseOwer, nowTimes, deadTime));
		hsInformation = HouseInfo({
			state: defaultState,	
			landRate: 2,		 
			ratingIndex: 2,
			huxing: _huxing,
			tenancy: _tenancy,
			rent: _rent,
			hopeYou: _hopeYou,
			houseAddress: _houseAddr,
			releaseTime: nowTimes,
			updateTime: nowTimes,
			dealineTime: deadTime,
			houseId: houseIds, 
			descibe: _describe,
			landlordInfo: _info,
			landlord: houseOwer,
			existed: true
		});
		houseInfos[houseIds] = hsInformation;
		PublishHouse(houseIds, houseOwer);
		// ReleaseHouseInfo(houseIds, 2, defaultState, _houseAddr, _huxing, _describe, _info, _tenancy, _rent, _hopeYou, nowTimes, deadTime, houseOwer, true);
		// PulishMessage(_landlord, houseInfo, houseIds);
	}

	/**
	 * title signContract
	 * @dev  _renter and _leaser sign how long agreement. It may be also including approve, send key
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , signHowLong: how long of the agreement}
	 */
	function signContract(bytes32 _houseId, uint _signHowLong, uint _rental) public returns (bool) {
		HouseInfo hsInfo = houseInfos[_houseId];
		require(hsInfo.existed == true, "House is not existed");
		require(hsInfo.state == HouseState.Renting, "House State is not right");
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
		houseInfos[_houseId].updateTime = nowTime;
	}
	/**
	 * title signContract
	 * dev  _renter and _leaser sign how long agreement. It may be also including approve, send key
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , signHowLong: how long of the agreement}
	 */
	 function withdrawPromise(bytes32 _houseId) {
	 	HouseInfo hs = houseInfos[_houseId];
	 	require(!hs.existed, "Not find the house");
	 	require(hs.state == HouseState.EndRent, "House rent is not finished");
	 	require(addrMoney[msg.sender] == promiseAmount, "Amount is not same");
	 	token.transfer(receiverPromiseMoney, addrMoney[msg.sender]);
	 	uint256 nowTime = now;
	 	houseInfos[_houseId].updateTime = nowTime;
	 }
	/**
	 * title getHouseInfo
	 * dev get release rent house information
	 * Parm {_index: the house informaion position}
	 */
	function getHouseInfo(bytes32 _houseId) public returns(HouseState, bytes32, uint8, string, uint8, bytes32, 
		bytes32, uint32, uint32, bytes32, uint, uint, address, bool) {

		HouseInfo houseInfo = houseInfos[_houseId];

		return (houseInfo.state, _houseId, houseInfo.ratingIndex, houseInfo.houseAddress, houseInfo.huxing,houseInfo.descibe,
			  houseInfo.landlordInfo, houseInfo.tenancy, houseInfo.rent, houseInfo.hopeYou, houseInfo.releaseTime, houseInfo.dealineTime, houseInfo.landlord, houseInfo.existed);		
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
	 * title breakContract
	 * dev  who break the contract and how to record it. And it will run by the contract or anyone call it
	 * Parm {}
	 * TODO
	 */
	function breakContract(address _renter, address _leaser) public returns (uint256 money) {

	}
	/**
	 * title sendKey
	 * dev _leaser send the key to _renter
	 * Parm {_leaser: the address of the leaser, _renter：the address of the renter , _lockKey: the key of the door}
	 */
	function sendKey(address _leaser, address _renter, address _lockKey) public returns (bool) {

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

// contract rentAndLeaser is rentBasic {

// 	event Lock(uint256 _lockTime);
// 	event Approval(address indexed _leaser, address indexed _renter, uint256 _value);
// 	/**
// 	 * @title lockBond
// 	 * @dev lock the bond of the renter and the leaser when the contract take effect
// 	 * @Parm {}
// 	 */
// 	function lockBond() internal notLocked onlyOwner {

// 	}
// 	/**
// 	 * @title unLockBond
// 	 * @dev when there are some one break the contract, the bond will transfer to the other
// 	 * @Parm {}
// 	 */
// 	function unLockBond() public locked onlyOwner {

// 	}
//    /**
// 	 * @title approve
// 	 * @dev approve the _renter the value of the people of the house
// 	 * @Parm {}
// 	 */
// 	function approve(address _renter, uint256 _value) public onlyLeaser returns (bool) {

// 	}
// 	/**
// 	 * @title Crowd-funding money for renter
// 	 * @dev renter can collect money by Crowd-Funding, and it should describe it clearly
// 	 * @Parm {_renter: who lauch the crowd-funding, long: how long it will contiune}
// 	 * return {} describe: It should include address,money,time
// 	 */
// 	function crowdFunding(address _renter, uint long) public returns (uint money) {

// 	} 
// 	/**
// 	 * @title Crowd-funding money who can lend the money 
// 	 * @dev Approve someone can lend money to me.
// 	 * @Parm {_msgsender: who lauch the crowd-funding, _lender: who lend money}
// 	 * return true/false
// 	 */
// 	function approveCrowdFunding(address _msgsender, address _lender) public returns (bool) {

// 	}


// }