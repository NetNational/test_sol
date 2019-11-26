pragma solidity ^0.4.24;
contract TenancyAgreement {
	struct Agreement {
		string  leaser; // 出租方
		string  tenant; // 承租方
		string  houseAddress; // 房屋地址
		string describe; // 房屋描述  
		bytes32 leaserSign; // 甲方签名 
		bytes32 tenantSign; // 乙方签名
		uint256  leaseTerm; //租赁期限
		uint256 rent; // 每月租金
		uint256 yearRent; // 年租金
		uint256 startTime; // 租赁开始
		uint256 endTime; // 结束租赁时间
		bool    isSign; // 是否已签约
		// address originator; // 发起方地址
	}
	mapping(bytes32 => Agreement) agrees;
	function newAgreement(string _leaser, bytes32 _houseId, string _houseAddress, string _describe, bytes32 _signInfo, uint256 _rental, uint _signHowLong) public returns(bool) {
		uint256 startTime = now;
		agrees[_houseId].leaser = _leaser;
		agrees[_houseId].houseAddress = _houseAddress;
		agrees[_houseId].describe = _describe;
		agrees[_houseId].leaserSign = _signInfo;
		agrees[_houseId].leaseTerm = _signHowLong;
		agrees[_houseId].rent = _rental;
	}
	function isAgree() public pure returns(bool isIndeed) {
        return true;
    }
	function tenantSign(bytes32 _houseId, string _tenant, uint256 _rental, uint _signHowLong, 
			bytes32 _signInfo) public returns(bool) {
		uint256 startTime = now;
		uint256 end  = startTime + (_signHowLong * 30) * 1 days;
		agrees[_houseId].tenant = _tenant;
		agrees[_houseId].yearRent = 12 * _rental;
		agrees[_houseId].startTime = startTime;
		agrees[_houseId].endTime = end;
		agrees[_houseId].isSign  = true;
	}
	function getAgreement(bytes32 _houseId) public returns(string, string, string, string, bytes32, bytes32) {
		Agreement ag = agrees[_houseId];
		return (ag.leaser, ag.tenant, ag.houseAddress, ag.describe, ag.leaserSign, ag.tenantSign);
	}
	function getRentTenancyInfo(bytes32 _houseId) public returns(uint256, uint256, uint256, uint256) {
		Agreement ag = agrees[_houseId];
		return (ag.rent, ag.yearRent, ag.startTime, ag.endTime);
	}
}