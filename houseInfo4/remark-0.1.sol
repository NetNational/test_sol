pragma solidity ^0.4.24;

contract Remark {
	// 租客对某一房源评价
	struct RemarkHouse {
		address tenant; // 租客地址	
		uint8   ratingIndex; // 评级级别
		string remarkLandlord; // 对房东评价
		uint256 optTime; // 评论时间
	}
	// 房东对某一租客评价
	struct RemarkTenant {
		address leaser; // 房东
		uint8   ratingIndex; // 评价级别
		string  remarkTenant; // 对租客评价
		uint256 optTime; // 评论时间
	}
	mapping(bytes32 => RemarkHouse) remarks; 
	mapping(bytes32 => RemarkTenant) remarkTenants;
	mapping(address => uint256) creditManager; 

	function isRemarkContract() public constant returns(bool isIndeed) {
		return true;
	} 
    // _refeAddr为被评价对象的地址
	function commentHouse(bytes32 _houseId, address _landlord, address _refeAddr, uint8 _ratingIndex, string _ramark) public returns(bool) {
		address sender = msg.sender;
		require(_ratingIndex >= 0, "Evaluation level must be greater than 0");
		if (sender != _landlord) { // 租赁人评价房东
			remarks[_houseId] = RemarkHouse(sender, _ratingIndex, _ramark, now);
			creditManager[_landlord] += _ratingIndex; 
		} else { // 房东评价租赁人
			creditManager[_refeAddr] += _ratingIndex;
			remarkTenants[_houseId] = RemarkTenant(sender, _ratingIndex, _ramark, now);
		}		
		return true;
	}

	function getRemarkHouse(bytes32 _houseId) public view returns(address, string, uint256) {
		RemarkHouse rh = remarks[_houseId];
		return (rh.tenant, rh.remarkLandlord, rh.optTime);
	}

	function getRemarkTenant(bytes32 _houseId) public view returns(address, string, uint256) {
		RemarkTenant rt = remarkTenants[_houseId];
		return (rt.leaser, rt.remarkTenant, rt.optTime);
	}
}
