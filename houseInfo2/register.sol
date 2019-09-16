pragma solidity ^0.4.24;

contract RegisterInterface {
    function isExitUserAddress(address _userAddress) public constant returns(bool isIndeed);
    function isExitUsername(string _username) public constant returns(bool isIndeed);
    function findAddrByName(string _username) public constant returns (address userAddress);
    function createUser(address _userAddress, string _username, string _pwd) public returns (uint index, uint nindex);
    function findUser(address _userAddress) public constant returns (address userAddresses, string username, uint time, uint index);
    function login(address _userAddr, string _userName, string _pwd) public returns(bool);
    function isLogin(address _userAddr) public returns(bool);
}

contract UserRegister {
	//定义用户数据结构
	struct UserStruct {
		address userAddress;
		uint time;
	    uint index;
	    string username;
	    string pwd;
	}

	//定义用户列表数据结构
	struct UserListStruct {
	    address userAddress;
	    uint index;
	}

	address[] userAddresses; //所有地址集合
	string[] usernames; //所有用户名集合
	mapping(address => UserStruct) userStruct; //账户个人信息

	mapping(string => UserListStruct) private userListStruct; //用户名映射地址
	mapping(address => bool) userLogins; // 判断用户是否登录

	//判断用户地址是否存在
	function isExitUserAddress(address _userAddress) public constant returns(bool isIndeed) {
	    if (userAddresses.length == 0) return false;
	    return (userAddresses[userStruct[_userAddress].index] == _userAddress);
	}

	//判断用户名是否存在
	function isExitUsername(string _username) public constant returns(bool isIndeed) {
	    if (usernames.length == 0) return false;
	    return (keccak256(usernames[userListStruct[_username].index]) == keccak256(_username));
	}

	//根据用户名查找对于的address
	function findAddrByName(string _username) public constant returns (address userAddress) {
	    require(isExitUsername(_username));
	    return userListStruct[_username].userAddress;
	}


	//创建用户信息
	function createUser(address _userAddress, string _username, string _pwd) public returns (uint index, uint nindex) {
	    require(!isExitUserAddress(_userAddress)); //如果地址已存在则不允许再创建

	    userAddresses.push(_userAddress); //地址集合push新地址
	    userStruct[_userAddress] = UserStruct(_userAddress, now,userAddresses.length - 1, _username, _pwd);
	    usernames.push(_username); //用户名集合push新用户
	    userListStruct[_username] = UserListStruct(_userAddress, usernames.length - 1); //用户所对应的地址集合

	    return (userAddresses.length - 1, usernames.length-1);
	}

	//获取用户个人信息
	function findUser(address _userAddress) public constant returns (address userAddresses, string username, uint time, uint index) {
	    require(isExitUserAddress(_userAddress));
	    return (
	        userStruct[_userAddress].userAddress,
	        userStruct[_userAddress].username,
	        userStruct[_userAddress].time,
	        userStruct[_userAddress].index); 
	}

	// 修改用户信息
	function updateUser(address _userAddress) public returns(bool) {
		return false;
	}

	function login(address _userAddr, string _userName, string _pwd) public returns(bool) {
		 if ((keccak256(userStruct[_userAddr].username) == keccak256(_userName)) && (keccak256(userStruct[_userAddr].pwd) == keccak256(_pwd))) {
		 	userLogins[_userAddr] = true;
		 	return true;
		 } 
		 return false;
	}
	function isLogin(address _userAddr) public returns(bool) {
		if (!userLogins[_userAddr]) {
			return false;
		}
		return true;
	}
}