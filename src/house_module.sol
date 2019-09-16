let abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_houseId",
				"type": "bytes32"
			}
		],
		"name": "getRentTenancyInfo",
		"outputs": [
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
				"type": "uint256"
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
			},
			{
				"name": "_tenant",
				"type": "string"
			},
			{
				"name": "_rental",
				"type": "uint256"
			},
			{
				"name": "_signHowLong",
				"type": "uint256"
			},
			{
				"name": "_signInfo",
				"type": "bytes32"
			}
		],
		"name": "tenantSign",
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
		"name": "getAgreement",
		"outputs": [
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
				"type": "string"
			},
			{
				"name": "",
				"type": "bytes32"
			},
			{
				"name": "",
				"type": "bytes32"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_leaser",
				"type": "string"
			},
			{
				"name": "_houseId",
				"type": "bytes32"
			},
			{
				"name": "_houseAddress",
				"type": "string"
			},
			{
				"name": "_describe",
				"type": "string"
			},
			{
				"name": "_signInfo",
				"type": "bytes32"
			},
			{
				"name": "_rental",
				"type": "uint256"
			},
			{
				"name": "_signHowLong",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	}
];
const Tx = require('ethereumjs-tx');
var Web3 = require("web3");
var web3 = new Web3();
web3.setProvider(new Web3.providers.HttpProvider("https://ropsten.infura.io/v3/2571ab4c0de14ffb87392fb9c3904375"));
// let web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

let contractAddress = "0x9939b2c8e46e26bea4b1814c487f4b03894c362c";
let userAddr = "0x3c8b2739a757bba8769e722ca914cc7624991c98"
let nonceMap = new Map();
// 通过web3调用合约内的方法
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
	const createFunc = contract.methods.releaseHouse(releaseHouse.houseAddr,releaseHous.huxing,releaseHous.describe,releaseHous._info,releaseHous._tenancy,releaseHous,releaseHous._rent,releaseHous._hopeYou); // it will be fail, if userAddr not in created user
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
requestSign("_houseId", 320000, "0xc96CeD51346896c5dF44E40eE41CDBfb67AE6888", "0x5FCC55798BD426BA7683ED01DA9DB35A64B96FFE9EEE1549C6EF673494A39FAB");
function requestSign(_houseId, _realRent, callAddr, privateKey) {
	// let callAddr = "0xc96CeD51346896c5dF44E40eE41CDBfb67AE6888";
	let contract = new web3.eth.Contract(abi, contractAddress, {gasPrice: '3000000', from: userAddr});
	// let privateKey = "0x5FCC55798BD426BA7683ED01DA9DB35A64B96FFE9EEE1549C6EF673494A39FAB";
	const createFunc = contract.methods.requestSign(_houseId, _realRent); // it will be fail, if userAddr not in created user
	const createABI = createFunc.encodeABI();
	let gas = 20000000000;
	CallContract(gas, callAddr, privateKey, createFunc, createABI);
}

