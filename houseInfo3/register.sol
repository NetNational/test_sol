pragma solidity ^0.4.24;

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
	// mapping(string => )

	event CreateUser(address indexed _userAddress, string _username); // 创建User事件
	event UpdateUser(address indexed _userAddr, string _userName);
	event LoginEvent(address indexed _userAddr, string _userName);
	event LoginOutEvent(address indexed _userAddr, string _userName);

    function isRegister() public constant returns(bool isIndeed) {
        return true;
    }
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

	// 判断用户是否已注册
	function isAlreayReg(address _userAddress, string _uername) public constant returns(bool) {
		return (isExitUserAddress(_userAddress) && isExitUsername(_uername));
	}

	//根据用户名查找对于的address
	function findAddrByName(string _username) public constant returns (address userAddress) {
	    require(isExitUsername(_username));
	    return userListStruct[_username].userAddress;
	}


	//创建用户信息
	function createUser(address _userAddress, string _username, string _pwd) public returns(bool) {
        require(!isAlreayReg(_userAddress, _username), "the name already occupy by some one or the address already register!"); //如果地址已存在则不允许再创建
	    userAddresses.push(_userAddress); //地址集合push新地址
	    userStruct[_userAddress] = UserStruct(_userAddress, now,userAddresses.length - 1, _username, _pwd);
	    usernames.push(_username); //用户名集合push新用户
	    userListStruct[_username] = UserListStruct(_userAddress, usernames.length - 1); //用户所对应的地址集合
	    CreateUser(_userAddress, _username); // 创建User事件
	    return true;
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
	function updateUser(address _userAddr, string _userName, string _pwd, string _newpwd) public returns(bool) {
	    UserStruct memory ustruct = userStruct[_userAddr];
	    if ((keccak256(userStruct[_userAddr].username) == keccak256(_userName)) && (keccak256(userStruct[_userAddr].pwd) == keccak256(_pwd))) {
	        userStruct[_userAddr].pwd = _newpwd;
	        UpdateUser(_userAddr, _userName);
	        return true;
	    }
		return false;
	}
	function login(address _userAddr, string _userName, string _pwd) public returns(bool) {
	     if (!isExitUserAddress(_userAddr)) {
	         createUser(_userAddr, _userName, _pwd);
	     }
	     require(!isLogin(_userAddr), "user already sign in");
	     if (!isLogin(_userAddr)) {
	         return false;
	     }
		 if ((keccak256(userStruct[_userAddr].username) == keccak256(_userName)) && (keccak256(userStruct[_userAddr].pwd) == keccak256(_pwd))) {
		 	userLogins[_userAddr] = true;
		 	LoginEvent(_userAddr, _userName);
		 	return true;
		 } 
		 return false;
	}
	function logout(address _userAddr, string _userName, string _pwd) public returns (bool) {
	    if (isLogin(_userAddr)) {
	        userLogins[_userAddr] = false;
	        LoginOutEvent(_userAddr, _userName);
	        return true;
	    } else {
	        return false;
	    }
	}
	function isLogin(address _userAddr) public returns(bool) {
		if (!userLogins[_userAddr]) {
			return false;
		}
		return true;
	}
}