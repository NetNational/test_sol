pragma solidity ^0.4.24;

interface RentBasicInterface {
	function houseExist(bytes32 _houseId) public returns(bool);
	function signAgreement(bytes32 _houseId, address _landlord, address _leaserAddr, uint _signHowLong, uint _rental) public returns(bool);
	function setSign(bytes32 _houseId) public returns(bool);
	function isExist() public constant returns(bool isIndeed);
	function setHouseState(bytes32 _houseId) public returns(bool);
}

contract TenancyAgreement {
	// 甲方
	struct LandlordAgree {
		uint8    payDead; // 交付最晚多少天内
		uint256  rent; // 每月租金
		uint256  tenancy; //租赁期限
		uint256  falsify; // 每日违约金
		uint256  idCard; // 身份证号
		string   houseUse; // 房屋用途 
		string   landlord; // 出租方
		string   houseAddress; // 房屋地址
	}
	// 甲方约定规则
	struct Rules {
		uint256  leaserPhone; // 租客电话
		uint256  landlordPhone; // 房东电话
		uint256  startTime; // 租赁开始
		uint256  endTime; // 结束租赁时间
		address  landlordAddr; // 房东地址
		string   payOne; // 维护方 
		bool     isSign; // 是否已签约
	}
	// 乙方
	struct LeaserAgree {
		uint256  cardId; // 身份证号
		uint     renewalMonth; // 续租提前时间
		uint 	 breakMonth;  // 提前终止时间
		string   tenant; // 承租方（乙方）
		address  leaserAddr; // 租户地址
	}
	address owner;
	RentBasicInterface houseInterface;
	mapping(bytes32 => LandlordAgree) public landlordAgrees;
	mapping(bytes32 => Rules) public rules;
	mapping(bytes32 => LeaserAgree) public leaserAgrees;

	event LandLordSign(address indexed _sender, uint _phoneNum, bytes32 _houseId);
	event LeaserSign(address indexed sender, uint _phoneNum, bytes32 _houseId);
	
	modifier judgeHouse(bytes32 _houseId) {
		// 校验房屋是否存在
		require(houseInterface.houseExist(_houseId), "The house is not exit or the house state is not in waiting rent!");
		_;
	}

	constructor(address _houseCrtAddr) {
		owner = msg.sender;
		houseInterface = RentBasicInterface(_houseCrtAddr);
		require(houseInterface.isExist(), "house contract call fail!");
	}

	function newAgreement(string _landlord, uint _idCard, uint _phoneNum, uint _rental, uint _signHowLong, bytes32 _houseId, string _houseAddr, uint _falsify, uint8 _houseDeadLine, string _payOne, string _houseUse)  public judgeHouse(_houseId) returns(bool) {
		landlordAgrees[_houseId] = LandlordAgree(_houseDeadLine, _rental, _signHowLong, _falsify, _idCard, _houseUse, _landlord, _houseAddr);
		rules[_houseId].landlordPhone = _phoneNum;
		rules[_houseId].landlordAddr = msg.sender;
		rules[_houseId].payOne = _payOne;
		require(houseInterface.setSign(_houseId), "Set sign agreement fail!");
		LandLordSign(msg.sender, _phoneNum, _houseId);
		return true;
	}

	function isAgree() public pure returns(bool isIndeed) {
        return true;
    }

    function tenantSign(bytes32 _houseId, string _tenant, uint _phoneNum, uint256 _cardId, uint _renewalMonth, uint _breakMonth) public judgeHouse(_houseId) returns(bool) {
		uint256 startTime = now;
		LandlordAgree landlordAgree = landlordAgrees[_houseId];
		uint256 end  = startTime + (landlordAgree.tenancy * 30) * 1 days;
		leaserAgrees[_houseId] = LeaserAgree(_cardId, _renewalMonth, _breakMonth, _tenant, msg.sender);
		rules[_houseId].startTime = startTime;
		rules[_houseId].endTime = end;
		rules[_houseId].leaserPhone  = _phoneNum;
		rules[_houseId].isSign  = true;
		require(houseInterface.signAgreement(_houseId, rules[_houseId].landlordAddr, msg.sender, landlordAgree.tenancy, landlordAgree.rent), "Sign the agree fail!");
		LeaserSign(msg.sender, _phoneNum, _houseId);
		return true;
	}

	function endRent(bytes32 _houseId) public returns(bool) {
		require(now > rules[_houseId].endTime, "The house is still in renting!");
		require(houseInterface.setHouseState(_houseId), "Set house end fail!");
		return true;
	}

	function getLeaseTime(bytes32 _houseId) public returns(uint, uint) {
		return (rules[_houseId].startTime, rules[_houseId].endTime);
	}

	function getRules(bytes32 _houseId) public returns(uint, uint, uint, uint, address) {
		Rules rule = rules[_houseId];
		return (rule.leaserPhone, rule.landlordPhone, rule.startTime, rule.endTime, rule.landlordAddr);
	}

	function getLandAgree(bytes32 _houseId) public returns(uint8, uint, uint, uint, string, string, string,uint256) {
		LandlordAgree ag = landlordAgrees[_houseId];
		return (ag.payDead, ag.rent, ag.tenancy, ag.falsify, ag.houseUse, ag.landlord, ag.houseAddress, ag.idCard);
	}

	function getLeaserAgree(bytes32 _houseId) public returns(uint256, uint, uint, string, address) {
		LeaserAgree ag = leaserAgrees[_houseId];
		if (msg.sender == owner) {
			return (ag.cardId, ag.renewalMonth, ag.breakMonth, ag.tenant, ag.leaserAddr);
		}
		return (0, ag.renewalMonth, ag.breakMonth, ag.tenant, ag.leaserAddr);
	}
}