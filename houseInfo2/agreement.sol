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
	}
	mapping(bytes32 => Agreement) agrees;
	/**
	 * dev rent house agreement, landlord call this agreement.
	 * Parm {_leaser: who rents out the house, _tenant: who rent the house, _houseId: the hash of the house,
	 * _houseAddress: the house position, _describe: the house describe, _rental: monthly rent, _signHowLong: lease term}
	 */
	constructor(string _leaser, bytes32 _houseId, string _houseAddress, string _describe, bytes32 _signInfo, uint256 _rental, uint _signHowLong){	
		agrees[_houseId].leaser = _leaser;
		agrees[_houseId].houseAddress = _houseAddress;
		agrees[_houseId].describe = _describe;
		agrees[_houseId].leaserSign = _signInfo;
		agrees[_houseId].leaseTerm = _signHowLong;
		agrees[_houseId].rent = _rental;	
	}
	/* title: tenantSign
	*  dev: tenant call this method to sign the rent house agreement 
	*  Param: 
	*/
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
	/* title: getAgreement
	*  dev: According to the house hash, query the agreement. 
	*  Param: 
	*/
	function getAgreement(bytes32 _houseId) public returns(string, string, string, string, bytes32, bytes32) {
		Agreement ag = agrees[_houseId];
		return (ag.leaser, ag.tenant, ag.houseAddress, ag.describe, ag.leaserSign, ag.tenantSign);
	}
	/* title: getRentTenancyInfo
	*  dev: Get Rent tenancy time inforamation 
	*  Param: 
	*/
	function getRentTenancyInfo(bytes32 _houseId) public returns(uint256, uint256, uint256, uint256) {
		Agreement ag = agrees[_houseId];
		return (ag.rent, ag.yearRent, ag.startTime, ag.endTime);
	}
}