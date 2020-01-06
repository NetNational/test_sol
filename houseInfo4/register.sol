pragma solidity ^0.4.24;

contract UserRegister {
	//定义用户数据结构
	struct UserStruct {
		address userAddress;
		uint8 state; // 用户登录状态， 1：创建，2：登录。3：登出
		uint userId; // 用户ID
		uint cardId; //身份证号
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
	mapping(address => UserStruct) private userStruct; //账户个人信息

	mapping(string => UserListStruct) private userListStruct; //用户名映射地址
	mapping(address => bool) userLogins; // 判断用户是否登录

	event CreateUser(address indexed _userAddress, string _username, uint _userId); // 创建User事件
	event UpdateUser(address indexed _userAddr, string _userName, uint _userId);
	event LoginEvent(address indexed _userAddr, string _userName);
	event LoginOutEvent(address indexed _userAddr, string _userName);
    // 只允许一部分管理员操作
	modifier onlyAdmin() {
        _;
	}
	modifier checkLogin(address _userAddr) {
		 require(isExitUserAddress(_userAddr), "User must be created first！");
	     require(!isLogin(_userAddr), "User already login!");
	     _;
	}

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
	    return compareStr(usernames[userListStruct[_username].index], _username);
	}

	// 判断用户是否已注册
	function isAlreayReg(address _userAddress, string _uername) public constant returns(bool) {
		return (isExitUserAddress(_userAddress) || isExitUsername(_uername));
	}

	//根据用户名查找对于的address
	function findAddrByName(string _username) public constant returns (address userAddress) {
	    require(isExitUsername(_username));
	    return userListStruct[_username].userAddress;
	}


	//创建用户信息
	function createUser(address _userAddress, string _username, string _pwd, uint _userId, uint _cardId) public returns(bool) {
        require(!isAlreayReg(_userAddress, _username), "the name already occupy by some one or the address already register!"); //如果地址已存在则不允许再创建
	    userAddresses.push(_userAddress); //地址集合push新地址
	    userStruct[_userAddress] = UserStruct(_userAddress, 1, _userId, _cardId, now, userAddresses.length - 1, _username, _pwd);
	    usernames.push(_username); //用户名集合push新用户
	    userListStruct[_username] = UserListStruct(_userAddress, usernames.length - 1); //用户所对应的地址集合
	    CreateUser(_userAddress, _username, _userId); // 创建User事件
	    return true;
	}
	//获取用户个人信息
	function findUser(address _userAddress) public constant returns (address,uint, string, uint, uint) {
	    require(isExitUserAddress(_userAddress));
	    return (
	        userStruct[_userAddress].userAddress,
	        userStruct[_userAddress].userId,
	        userStruct[_userAddress].username,
	        userStruct[_userAddress].time,
	        userStruct[_userAddress].index); 
	}
	// 修改用户信息
	function updateUser(address _userAddr, string _userName, string _pwd, string _newpwd, uint _userId) public returns(bool) {
	    UserStruct user = userStruct[_userAddr];
	    if (compareStr(user.username, _userName) && compareStr(user.pwd, _pwd)) {
	        userStruct[_userAddr].userAddress =_userAddr;
	        userStruct[_userAddr].pwd = _newpwd;
	        userStruct[_userAddr].userId = _userId;
	        UpdateUser(_userAddr, _userName, _userId);
	        return true;
	    }
		return false;
	}

	function login(address _userAddr, string _userName, string _pwd) public checkLogin(_userAddr) returns(bool) {
	     // require(isExitUserAddress(_userAddr), "User must be created first！");
	     // require(!isLogin(_userAddr), "User already login!");
	     UserStruct user = userStruct[_userAddr];
	     if (compareStr(user.username, _userName) && compareStr(user.pwd, _pwd) && user.userAddress == _userAddr) {
	     	userLogins[_userAddr] = true;
	     	userStruct[_userAddr].state = 2;
		 	LoginEvent(_userAddr, _userName);
		 	return true;
	     }
		 return false;
	}
	function compareStr(string _str1, string _str2) public returns(bool) {
        if(keccak256(abi.encodePacked(_str1)) == keccak256(abi.encodePacked(_str2))) {
            return true;
        }else {
            return false;
        }
    }
	function logout(address _userAddr, string _userName, string _pwd) public returns (bool) {
	    if (isLogin(_userAddr)) {
	        userLogins[_userAddr] = false;
	        userStruct[_userAddr].state = 3;
	        LoginOutEvent(_userAddr, _userName);
	        return true;
	    } else {
	        return false;
	    }
	}
	// 获取链上状态
	function chainStatus(address _userAddr) public returns(uint8) {
		return userStruct[_userAddr].state;
	}
	// 是否登录
	function isLogin(address _userAddr) public returns(bool) {
		if (!userLogins[_userAddr]) {
			return false;
		}
		return true;
	}

	// 授权某人访问
	function approveVisit() {
		
	}
	// 授权用户找回密码
	function approveFindPwd() public onlyAdmin returns(bool) {

	}
	// 找回密码
	function findPwd() public  returns(string) {
		// 必须被管理员授权
		
	}
}