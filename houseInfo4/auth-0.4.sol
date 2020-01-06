pragma solidity ^0.4.24;
// 房源认证相关功能
contract Authentication {
	// 房屋所有权信息
	struct AuthCtx {
		uint    idCard; // 业主身份证
		uint    guid; //房屋的唯一码
		uint    uptimes; // 更新次数
		string  owername; // 业主名字
		// bytes32 houseId; // 房屋id
		address authAddr; // 房屋认证地址
		bool    isAuth; // 是否已经认证
	}
	struct InspctCtx {
		address  approver; // 授权者的地址
		address  authorizedAddr; // 被授权的地址 
		bytes32  houseId; // 房源id
		bool     canInspct; //是否可以查看
	}
	address owner;
	mapping(bytes32 => InspctCtx) approvelists; // 拥有查看某个房屋的所有权的列表
	mapping(bytes32 => AuthCtx)   authCtxs; // owner address => 房屋所有权信息
	mapping(address => bool)  agreetlists; // 同意修改授权
	mapping(uint256 => bool)  alAuthlist; //已经认证房源列表
	mapping(uint256 => []bytes32) houseIdSets; // 房源houseId历史集合(guid => houseId集合)
	bytes32 public houseId;

	event AuthHouse(address indexed _owner, string _owername, bytes32 _houseId);
	event ApproveVist(address indexed sender, address indexed _addr, bytes32 _houseId);
	event ApproveUpdate(address indexed owner, address indexed _addr); // 超级管理员允许用户修改房屋xinx
	event UpdateHouse(address indexed _owner, bytes32 _oldId, bytes32 _newId); // 更新授权信息
	event ShiftHouse(address indexed _addr, address indexed _newOwner, string _newowername);

	modifier onlyOwner() {
		require(msg.sender == owner, "Only the contract creater can operate!");
		_;
	}

	modifier onlyApprove() {
		require(agreetlists[msg.sender], "Not approve to update house infomation, or already update!");
		_;
	}

	constructor() {
		owner = msg.sender;
	}
	// 合约存在
	function contrctExist() public constant returns(bool isIndeed) {
		return true;
	}
	function getHouseId() public constant returns(bytes32) {
		return houseId;
	}
	function getHouseIds(bytes32 _houseId) public constant returns(bytes32) {
		return authCtxs[_houseId].houseId;
	}
	function getIsAuth(bytes32 _houseId) public constant returns(bool) {
		return authCtxs[_houseId].isAuth;
	}
	// 认证房屋, 主要依靠房屋的唯一码（GUID）+业主身份证+业主姓名
	function authHouse(uint _idCard, uint _guid, string _owername) public returns(bytes32) {
		require(!alAuthlist[_guid], "This house already be Authentication!");
		address sender = msg.sender;
		bytes32 houseIds = keccak256(abi.encodePacked(sender, _idCard, 1, _guid, _owername));
		authCtxs[houseIds] = AuthCtx(_idCard, _guid, 1, _owername, sender, true);
		alAuthlist[_guid] = true;
		houseId = houseIds;
		AuthHouse(sender, _owername, houseIds);
		return houseIds;
	}
	// 授权某人查询房屋所有权
	// 多个房子只允许查看其中的一个时，需要传入houseId
	function approveVisit(address _addr, bytes32 _houseId) public returns(bool) {
		address sender = msg.sender;
		require(authCtxs[_houseId].isAuth, "House is not exist, please authenticate the house!");
		approvelists[_houseId] = InspctCtx(sender, _addr, authCtxs[_houseId].houseId, true);
		ApproveVist(sender, _addr, authCtxs[_houseId].houseId);
		return true;
	}
	// 查看房屋所有权
	function getHouseOwer(address _approver, bytes32 _houseId) public returns(uint, uint, string, bytes32) {
		address sender = msg.sender;
		require(approvelists[_houseId].canInspct, "The address need be approve visit the house");
		address houseOwner = approvelists[_houseId].approver;
		AuthCtx tempCtx = authCtxs[_houseId];
		return (tempCtx.idCard, tempCtx.guid, tempCtx.owername, tempCtx.houseId);
	}
	// 允许授权更新
	function approveUpdate(address _addr) public onlyOwner returns(bool) {
		agreetlists[_addr] = true;
		ApproveUpdate(owner, _addr);
		return true;
	} 
	// 更新房屋信息
	function updateHouse(address _addr, bytes32 _houseId) public onlyApprove returns(bytes32) {
		address _addr = msg.sender;
		require(authCtxs[_houseId].isAuth, "House is not authenticated!");
		bytes32 _oldId = authCtxs[_houseId].houseId;
		uint num = authCtxs[_houseId].uptimes;
		bytes32 _newId = keccak256(abi.encodePacked(_addr, _idCard, num, _guid, _owername));
		authCtxs[_houseId] = AuthCtx(_idCard, _guid, _owername, _newId, true);
		agreetlists[_addr] = false;
		authCtxs[_houseId].uptimes += 1
		UpdateHouse(_addr,  _oldId, _newId);
		return _newId;
	}
	// 将房屋卖给别人
	function shiftHouse(address _newOwner, uint _newidCard, uint _guid, string _newowername) public returns(bytes32) {
		address _addr = msg.sender;
		require(authCtxs[_addr].isAuth, "House is not authenticated!");
		bytes32 _oldId = authCtxs[_addr].houseId;
		bytes32 _newId = keccak256(abi.encodePacked(_newOwner, _newidCard, _guid, _newowername));
		authCtxs[_newOwner] = AuthCtx(_newidCard, _guid, _newowername, _newId, true);
		authCtxs[_addr].isAuth = false;
		ShiftHouse(_addr, _newOwner, _newowername);
		return _newId;
	}
}




