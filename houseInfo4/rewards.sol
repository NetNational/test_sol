let abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "withdraw",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "punishAddr",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"name": "_reason",
				"type": "string"
			},
			{
				"name": "_punishLevel",
				"type": "uint8"
			}
		],
		"name": "breakContract",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"name": "_ratingIndex",
				"type": "uint8"
			},
			{
				"name": "_ramark",
				"type": "string"
			}
		],
		"name": "commentHouse",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			}
		],
		"name": "deadReleaseHouse",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "bytes32"
			}
		],
		"name": "hsReleaseInfos",
		"outputs": [
			{
				"name": "state",
				"type": "uint8"
			},
			{
				"name": "tenancy",
				"type": "uint32"
			},
			{
				"name": "rent",
				"type": "uint256"
			},
			{
				"name": "releaseTime",
				"type": "uint256"
			},
			{
				"name": "updateTime",
				"type": "uint256"
			},
			{
				"name": "dealineTime",
				"type": "uint256"
			},
			{
				"name": "existed",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "bytes32"
			}
		],
		"name": "remarkTenants",
		"outputs": [
			{
				"name": "leaser",
				"type": "address"
			},
			{
				"name": "ratingIndex",
				"type": "uint8"
			},
			{
				"name": "remarkTenant",
				"type": "string"
			},
			{
				"name": "operateTime",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"name": "_realRent",
				"type": "uint256"
			}
		],
		"name": "requestSign",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "distributeRemarkAddr",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			}
		],
		"name": "getHouseBasicInfo",
		"outputs": [
			{
				"name": "",
				"type": "bytes32"
			},
			{
				"name": "",
				"type": "uint8"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "uint8"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "receiverPromiseMoney",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "bytes32"
			}
		],
		"name": "houseInfos",
		"outputs": [
			{
				"name": "landRate",
				"type": "uint8"
			},
			{
				"name": "ratingIndex",
				"type": "uint8"
			},
			{
				"name": "huxing",
				"type": "uint8"
			},
			{
				"name": "houseAddress",
				"type": "string"
			},
			{
				"name": "houseId",
				"type": "bytes32"
			},
			{
				"name": "descibe",
				"type": "string"
			},
			{
				"name": "landlordInfo",
				"type": "string"
			},
			{
				"name": "hopeYou",
				"type": "string"
			},
			{
				"name": "landlord",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "addrMoney",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"name": "_name",
				"type": "string"
			},
			{
				"name": "_signHowLong",
				"type": "uint256"
			},
			{
				"name": "_rental",
				"type": "uint256"
			},
			{
				"name": "_yearRent",
				"type": "uint256"
			}
		],
		"name": "signAgreement",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "hsInformation",
		"outputs": [
			{
				"name": "landRate",
				"type": "uint8"
			},
			{
				"name": "ratingIndex",
				"type": "uint8"
			},
			{
				"name": "huxing",
				"type": "uint8"
			},
			{
				"name": "houseAddress",
				"type": "string"
			},
			{
				"name": "houseId",
				"type": "bytes32"
			},
			{
				"name": "descibe",
				"type": "string"
			},
			{
				"name": "landlordInfo",
				"type": "string"
			},
			{
				"name": "hopeYou",
				"type": "string"
			},
			{
				"name": "landlord",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseAddr",
				"type": "string"
			},
			{
				"name": "_huxing",
				"type": "uint8"
			},
			{
				"name": "_describe",
				"type": "string"
			},
			{
				"name": "_info",
				"type": "string"
			},
			{
				"name": "_tenancy",
				"type": "uint32"
			},
			{
				"name": "_rent",
				"type": "uint256"
			},
			{
				"name": "_hopeYou",
				"type": "string"
			}
		],
		"name": "releaseHouse",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "saveTenanantAddr",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			}
		],
		"name": "getHouseReleaseInfo",
		"outputs": [
			{
				"name": "",
				"type": "uint8"
			},
			{
				"name": "",
				"type": "uint32"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "bytes32"
			}
		],
		"name": "remarks",
		"outputs": [
			{
				"name": "tenant",
				"type": "address"
			},
			{
				"name": "ratingIndex",
				"type": "uint8"
			},
			{
				"name": "remarkLandlord",
				"type": "string"
			},
			{
				"name": "operateTime",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_token",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "houseHash",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "_defaultState",
				"type": "uint8"
			},
			{
				"indexed": false,
				"name": "_tenancy",
				"type": "uint32"
			},
			{
				"indexed": false,
				"name": "_rent",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "_releaseTime",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "_deadTime",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "existed",
				"type": "bool"
			}
		],
		"name": "ReleaseInfo",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "houseHash",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "rating",
				"type": "uint8"
			},
			{
				"indexed": false,
				"name": "_houseAddr",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "_huxing",
				"type": "uint8"
			},
			{
				"indexed": false,
				"name": "_describe",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "_info",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "_hopeYou",
				"type": "string"
			},
			{
				"indexed": true,
				"name": "_landlord",
				"type": "address"
			}
		],
		"name": "ReleaseBasic",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "_sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "_signHowLong",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "_rental",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "_signatrue",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "_time",
				"type": "uint256"
			}
		],
		"name": "SignContract",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "_commenter",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_rating",
				"type": "uint8"
			},
			{
				"indexed": false,
				"name": "_ramark",
				"type": "string"
			}
		],
		"name": "CommentHouse",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "_sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"name": "_realRent",
				"type": "uint256"
			},
			{
				"indexed": true,
				"name": "saveTenanantAddr",
				"type": "address"
			}
		],
		"name": "RequestSign",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"indexed": true,
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_reason",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "_punishLevel",
				"type": "uint8"
			},
			{
				"indexed": false,
				"name": "uptime",
				"type": "uint256"
			}
		],
		"name": "BreakContract",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"indexed": true,
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "nowTime",
				"type": "uint256"
			}
		],
		"name": "WithdrawDeposit",
		"type": "event"
	}
];
function test() {
	var myEvent = metacoin.Transfer();
myEvent.watch(function (err, result) {
    if (!err) {
        if (result.transactionHash == txhash) {
            var account_one_balance = metacoin.getBalance.call(account_one);
            console.log("account one balance after sendCoin:", account_one_balance.toNumber());
        }
    } else {
        console.log(err);
    }
    myEvent.stopWatching();
});
}
const Tx = require('ethereumjs-tx');
var Web3 = require("web3");
var web3 = new Web3();
web3.setProvider(new Web3.providers.HttpProvider("https://ropsten.infura.io/v3/2571ab4c0de14ffb87392fb9c3904375"));
// let web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

let contractAddress = "0x3aa583cad3a439ea56cd63654eabb353c09f66bd";
let userAddr = "0x3c8b2739a757bba8769e722ca914cc7624991c98"
let nonceMap = new Map();
// 通过web3调用合约内的方法
HouseRealse()
function HouseRealse() {
	let releaseHouse = {
		houseAddr: "北京市海淀区西土城北京邮电大学南门",
		huxing: 2,
		describe: " 距离北邮教三很近，方便去教三学习，一共四个床位，还算宽敞，图片有些乱，上个租户刚走，还没收拾好",
		_info: "房子很漂亮，采光很好",
		_tenancy: 12,
		_rent: 320000,
		_hopeYou: "我想这样对于大家会比较方便；均摊：因为是合住，所以水费、电费、煤气费、都是大家自己均摊的，用多少摊多少"
	}
	const createFunc = contract.methods.releaseHouse(releaseHouse.houseAddr,releaseHouse.huxing,
	releaseHouse.describe,releaseHouse._info,releaseHouse._tenancy,releaseHouse._rent,
	releaseHouse._hopeYou); // it will be fail, if userAddr not in created user
	const createABI = createFunc.encodeABI();
	let gas = 20000000000;
	CallContract(gas, "0xc96CeD51346896c5dF44E40eE41CDBfb67AE6888","0x5FCC55798BD426BA7683ED01DA9DB35A64B96FFE9EEE1549C6EF673494A39FAB", createFunc, createABI);
}

function CallContract(gas, callAddr, privateKey, createFunc, createABI) {
	let contract = new web3.eth.Contract(abi, contractAddress);
	let nonce;
	web3.eth.getBalance(callAddr).then(console.log);
	web3.eth.getTransactionCount(callAddr, 'pending').then(_nonce => {
		if (nonceMap.has(_nonce)) {
			_nonce += 1;
		}
		nonceMap.set(_nonce, true);
		nonce = _nonce.toString(16);
		const txParams = {
		  gasPrice: gas,
	      gasLimit: 2000000,
	      to: contractAddress,
	      data: createABI,
	      from: callAddr,
	      chainId: 3,
	      nonce: '0x' + nonce
		};
	 	web3.eth.accounts.signTransaction(txParams, privateKey).then(signedTx => {
	 		web3.eth.sendSignedTransaction(signedTx.rawTransaction).then(receipt => {
	 			console.log(receipt);
	 			if (receipt.status) {
	 				console.log(receipt.transactionHash);
	 			} else {
	 				console.log("this user already regiester");
	 			}
	 		}).catch(err => {
	 			console.log(err);
	 		});
		});	  			
    });
}
// requestSign("_houseId", 320000, "0xc96CeD51346896c5dF44E40eE41CDBfb67AE6888", "0x5FCC55798BD426BA7683ED01DA9DB35A64B96FFE9EEE1549C6EF673494A39FAB");
function requestSign(_houseId, _realRent, callAddr, privateKey) {
	// let callAddr = "0xc96CeD51346896c5dF44E40eE41CDBfb67AE6888";
	let contract = new web3.eth.Contract(abi, contractAddress, {gasPrice: '3000000', from: userAddr});
	// let privateKey = "0x5FCC55798BD426BA7683ED01DA9DB35A64B96FFE9EEE1549C6EF673494A39FAB";
	const createFunc = contract.methods.requestSign(_houseId, _realRent); // it will be fail, if userAddr not in created user
	const createABI = createFunc.encodeABI();
	let gas = 20000000000;
	CallContract(gas, callAddr, privateKey, createFunc, createABI);
}

