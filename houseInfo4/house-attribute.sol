pragma solidity ^0.4.24;
// 房源认证相关功能
contract Authentication {
	// 房屋所有权信息
	struct AuthCtx {
		uint32 idCard; // 业主身份证
		uint   guid; //房屋的唯一码
		string owername; // 业主名字
		bytes32 houseId; // 房屋id
		bool    isAuth; // 是否已经认证
	}
	struct InspctCtx {
		address approver; // 授权者的地址
		bytes32  houseId; // 房源id
		bool   canInspct; //是否可以查看
	}
	address owner;
	mapping(address => InspctCtx) approvelists; // 拥有查看某个房屋的所有权的列表
	mapping(address => AuthCtx)   authCtxs; // owner address => 房屋所有权信息
	mapping(uint256 => bool)  alAuthlist; //已经认证房源列表
	mapping(address => bool)  agreetlists; // 同意修改授权
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
	function contrctExist() public constant returns(bool) {
		return true;
	}
	function getHouseId() public constant returns(bytes32) {
		return houseId;
	}
	function getHouseIds(address _addr) public constant returns(bytes32) {
		return authCtxs[_addr].houseId;
	}
	function getIsAuth(address _addr) public constant returns(bool) {
		return authCtxs[_addr].isAuth;
	}
	// 认证房屋, 主要依靠房屋的唯一码（GUID）+业主身份证+业主姓名
	function authHouse(uint32 _idCard, uint _guid, string _owername) public returns(bytes32) {
		require(!alAuthlist[_guid], "This house already be Authentication!");
		address sender = msg.sender;
		bytes32 houseIds = keccak256(abi.encodePacked(sender, _idCard, _guid, _owername));
		authCtxs[sender] = AuthCtx(_idCard, _guid, _owername, houseIds, true);
		alAuthlist[_guid] = true;
		houseId = houseIds;
		AuthHouse(sender, _owername, houseIds);
		return houseIds;
	}
	// 授权某人查询房屋所有权
	function approveVisit(address _addr) public returns(bool) {
		address sender = msg.sender;
		require(authCtxs[sender].isAuth, "House is not exist, please authenticate the house!");
		approvelists[_addr] = InspctCtx(sender, authCtxs[sender].houseId, true);
		ApproveVist(sender, _addr, authCtxs[sender].houseId);
		return true;
	}
	// 查看房屋所有权
	function getHouseOwer() public returns(uint32, uint, string, bytes32) {
		address sender = msg.sender;
		require(approvelists[sender].canInspct, "The address need be approve visit the house");
		address houseOwner = approvelists[sender].approver;
		AuthCtx tempCtx = authCtxs[houseOwner];
		return (tempCtx.idCard, tempCtx.guid, tempCtx.owername, tempCtx.houseId);
	}
	// 允许授权更新
	function approveUpdate(address _addr) public onlyOwner returns(bool) {
		agreetlists[_addr] = true;
		ApproveUpdate(owner, _addr);
		return true;
	} 
	// 更新房屋信息
	function updateHouse(uint32 _idCard, uint _guid, string _owername) public onlyApprove returns(bytes32) {
		address _addr = msg.sender;
		require(authCtxs[_addr].isAuth, "House is not authenticated!");
		bytes32 _oldId = authCtxs[_addr].houseId;
		bytes32 _newId = keccak256(abi.encodePacked(_addr, _idCard, _guid, _owername));
		authCtxs[_addr] = AuthCtx(_idCard, _guid, _owername, _newId, true);
		agreetlists[_addr] = false;
		UpdateHouse(_addr,  _oldId, _newId);
		return _newId;
	}
	// 将房屋卖给别人
	function shiftHouse(address _newOwner, uint32 _newidCard, uint _guid, string _newowername) public returns(bytes32) {
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




