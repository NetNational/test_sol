let getContract = require("./common/contract_com.js").GetContract;
let filePath = "./ethererscan/house_abi.json";
let contractAddress = "0xc63b3f24321ff6554d358a045f195234f59fb457";
let web3 = require("./common/contract_com.js").web3;
let Web3EthAbi = require('web3-eth-abi');
let nonceMap = new Map();
let RegisterFun = require("./get_register");
async function init() {
	let contract = await getContract(filePath, contractAddress);
	return contract;
}
init().then(con => {
	let addr = "0xaDCe9984d4d2E3936A0eB6F21a6105217a3E8766";	
	let priKey = "0x36923250A8BF14292202A7932DA90A3222560E8FF3C0426FC6B6199F1EE29023";
	let username = "zs";
	let houseAddr = "It lies in SanFan";
	let des = "It's very beautiful, and it has a lot of fun";
	let info = "";
	let hopeCtx = "Hope you are easygoing";
	// releaseHouse(con, addr, priKey, houseAddr, 5, des, info, 12, 320000000000, hopeCtx).then(res => {
	// 	if (res) {
	// 		console.log(res);
	// 	}
	// });
	// house id : 0x2a43eecd35d6b76aef7c08c9ab761ae366bd19018492fe8de12799ec342ac69f
	let addr2 = "0x5b0ccb1c93064Eb8Fd695a60497240efd94A44ed";
	let priKey2 = "0x502D29356356AE02B7E23ECC851CCA0F21FE9CDADEF1FBAB158EB82611F27229";
	let houseId = "0xb1bafe0d4472bed1b888c6ef3909d90a4b30f1e549c6cb944910719f4688593a";
	let realRent = 320000000000;
	// requestSign(con, addr2, priKey2, houseId, realRent).then(res => {
	// 	if (res) {
	// 		console.log(res);
	// 	}
	// });
	let signHowLong = 12;
	let rental = 320000000000;
	let yearRent = 12;
	// let addr2 = "0x5b0ccb1c93064Eb8Fd695a60497240efd94A44ed";
	// let priKey2 = "0x502D29356356AE02B7E23ECC851CCA0F21FE9CDADEF1FBAB158EB82611F27229";
	let username2 = "ym";
	// signAgreement(con, addr2, priKey2, houseId, username2, signHowLong, rental, yearRent).then(res => {
	// 	console.log(res)
	// })

});

function checkLogin(addr) {
	// Must login in first
	let flag = false;
	return new Promise((resolve) => {
		RegisterFun.initReg().then(con => {
			RegisterFun.isLogin(con, addr).then(res => {
				flag = res;
				if (flag) { // Already sign
					flag = true;
				}
				resolve(flag);
			});
		});
	});
}

function releaseHouse(contract, addr, privateKey, houseAddr, huxing, des, info, tenancy, rent, hopeCtx) {
	return new Promise((resolve, reject) => {
		checkLogin(addr).then(flag => {
			if (!flag) {
				console.log("Please login in first");
				resolve(false);
			} else {
				const releaseFun = contract.methods.releaseHouse(houseAddr, huxing, des, info, tenancy, rent, hopeCtx);
	    		const relABI = releaseFun.encodeABI();
			    packSendMsg(addr, privateKey, contractAddress, relABI).then(receipt => {
		        	if (receipt) {
		        		console.log("Release house success!");
		        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'RelBasic' || o.name == 'RelInfo') && o.type === 'event');
						if (JSON.stringify(receipt.logs) != '[]') {
							const log = receipt.logs.find(
								l => l.topics.includes(eventJsonInterface.signature)
							)
							let houseRel = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
			   				if (houseRel) {
			   					resolve(houseRel);
			   				} else {
			   					resolve(receipt);
			   				}
						}
		        	} else {
		        		console.log("Release house fail!");
		        	}
				}).catch(err => {
					console.log("Release fail!");
					reject(err);
				});
			}
		});
	});
}

function requestSign(contract, addr, privateKey, houseId, realRent) {
	return new Promise((resolve, reject) => {
		// Judge whether the user has logged in
		checkLogin(addr).then(flag => {
			if (!flag) {
				console.log("Please login in first");
				resolve(false);
			} else {
				const reqFun = contract.methods.requestSign(houseId, realRent);
			    const reqABI = reqFun.encodeABI();
			    console.log("Start request!", addr);
			    packSendMsg(addr, privateKey, contractAddress, reqABI).then(receipt => {
		        	if (receipt) {
		        		console.log("Request the house success!");
		        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'RequestSign') && o.type === 'event');
						if (JSON.stringify(receipt.logs) != '[]') {
							const log = receipt.logs.find(
								l => l.topics.includes(eventJsonInterface.signature)
							)
							let houseRel = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
			   				if (houseRel) {
			   					resolve(houseRel);
			   				} else {
			   					resolve(receipt);
			   				}
						}
		        	} else {
		        		console.log("Release house fail!");
		        	}
				}).catch(err => {
					console.log("Release fail!", err);
					reject(err);
				});
			}
		});
		
	});
}

function signAgreement(contract, addr, privateKey, houseId, name, signHowLong, rental, yearRent) {
	return new Promise((resolve, reject) => {
		checkLogin(addr).then(flag => {
			if (!flag) {
				console.log("Please login in first");
				resolve(false);
			} else {
				const reqFun = contract.methods.signAgreement(houseId, name, signHowLong, rental, yearRent);
			    const reqABI = reqFun.encodeABI();
			    console.log("Start sign the agreement!", addr);
			    packSendMsg(addr, privateKey, contractAddress, reqABI).then(receipt => {
		        	if (receipt) {
		        		console.log("Sign success!");
		        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'SignContract') && o.type === 'event');
						if (JSON.stringify(receipt.logs) != '[]') {
							const log = receipt.logs.find(
								l => l.topics.includes(eventJsonInterface.signature)
							)
							let houseRel = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
			   				if (houseRel) {
			   					resolve(houseRel);
			   				} else {
			   					resolve(receipt);
			   				}
						}
		        	} else {
		        		console.log("Sign Agreement fail!");
		        	}
				}).catch(err => {
					console.log("Sign fail!", err);
					reject(err);
				});
			}
		});
	});
}

function withdraw(contract, addr, privateKey, houseId, amount) {
	return new Promise((resolve, reject) => {
		const withFun = contract.methods.withdraw(houseId, amount);
	    const withABI = withFun.encodeABI();
	    packSendMsg(addr, privateKey, contractAddress, withABI).then(receipt => {
        	if (receipt) {
        		console.log("Withdraw the coin success!");
        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'WithdrawDeposit') && o.type === 'event');
				if (JSON.stringify(receipt.logs) != '[]') {
					const log = receipt.logs.find(
						l => l.topics.includes(eventJsonInterface.signature)
					)
					let houseRel = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
	   				if (houseRel) {
	   					resolve(houseRel);
	   				} else {
	   					resolve(receipt);
	   				}
				}
        	} else {
        		console.log("Withdraw the coin fail!");
        	}
		}).catch(err => {
			console.log("Withdraw occure error!");
			reject(err);
		});
	});
}

function breakContract(contract, addr, privateKey, houseId, reason) {
	return new Promise((resolve, reject) => {
		checkLogin(addr).then(flag => {
			if (!flag) {
				console.log("Please login in first");
				resolve(false);
			} else {
				const reqFun = contract.methods.breakContract(houseId, reason);
			    const reqABI = reqFun.encodeABI();
			    console.log("Start Break the contract!", addr);
			    packSendMsg(addr, privateKey, contractAddress, reqABI).then(receipt => {
		        	if (receipt) {
		        		console.log("Break Contract success!");
		        		web3.eth.getTransactionReceipt(receipt.txHash).then(transaction => {
		        			  console.log("getTransactionReceipt", transaction);
		        		});
		        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'BreakContract') && o.type === 'event');
						if (JSON.stringify(receipt.logs) != '[]') {
							const log = receipt.logs.find(
								l => l.topics.includes(eventJsonInterface.signature)
							)
							let houseRel = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
			   				if (houseRel) {
			   					resolve(houseRel);
			   				} else {
			   					resolve(receipt);
			   				}
						}
		        	} else {
		        		console.log("Break the contract fail!");
		        	}
				}).catch(err => {
					console.log("Break the contract occure error!", err);
					reject(err);
				});
			}
		});
	});
}

function checkBreak(contract, addr, privateKey, houseId, punishAmount, punishAddr) {
	return new Promise((resolve, reject) => {
		checkLogin(addr).then(flag => {
			if (!flag) {
				console.log("Please login in first");
				resolve(false);
			} else {
				const reqFun = contract.methods.checkBreak(houseId, reason);
			    const reqABI = reqFun.encodeABI();
			    console.log("Start Break the contract!", addr);
			    packSendMsg(addr, privateKey, contractAddress, reqABI).then(receipt => {
		        	if (receipt) {
		        		console.log("Break Contract success!");
		        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'ApprovalBreak') && o.type === 'event');
						if (JSON.stringify(receipt.logs) != '[]') {
							const log = receipt.logs.find(
								l => l.topics.includes(eventJsonInterface.signature)
							)
							let houseRel = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
			   				if (houseRel) {
			   					resolve(houseRel);
			   				} else {
			   					resolve(receipt);
			   				}
						}
		        	} else {
		        		console.log("Break the contract fail!");
		        	}
				}).catch(err => {
					console.log("Break the contract occure error!", err);
					reject(err);
				});
			}
		});
	});
}

function commentHouse(contract, addr, privateKey, houseId, ratingIndex, remark) {
	return new Promise((resolve, reject) => {
		checkLogin(addr).then(flag => {
			if (!flag) {
				console.log("Please login in first");
				resolve(false);
			} else {
				const reqFun = contract.methods.commentHouse(houseId, ratingIndex, remark);
			    const reqABI = reqFun.encodeABI();
			    console.log("Start comment the house!", addr);
			    packSendMsg(addr, privateKey, contractAddress, reqABI).then(receipt => {
		        	if (receipt) {
		        		console.log("Comment the house success!");
		        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'CommentHouse') && o.type === 'event');
						if (JSON.stringify(receipt.logs) != '[]') {
							const log = receipt.logs.find(
								l => l.topics.includes(eventJsonInterface.signature)
							)
							let houseRel = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
			   				if (houseRel) {
			   					resolve(houseRel);
			   				} else {
			   					resolve(receipt);
			   				}
						}
		        	} else {
		        		console.log("Comment the house fail!");
		        	}
				}).catch(err => {
					console.log("Comment the house error!", err);
					reject(err);
				});
			}
		});
	});
}



function packSendMsg(formAddr, privateKey, toAddr, createABI) {
		let gas, nonce;
		return new Promise((resolve, reject) => {
			gas = 2000000000;
			web3.eth.getTransactionCount(formAddr, 'pending').then(_nonce => {
				if (nonceMap.has(formAddr) && (nonceMap[formAddr] == _nonce)) {
		             _nonce += 1
		        }
		        nonceMap.set(formAddr, _nonce);
				nonce = _nonce.toString(16);
				const txParams = {
				  gasPrice: gas,
			      gasLimit: 2000000,
			      to: toAddr,
			      data: createABI,
			      from: formAddr,
			      chainId: 3,
			      nonce: '0x' + nonce
				}
				web3.eth.accounts.signTransaction(txParams, privateKey).then(signedTx => {
			 		web3.eth.sendSignedTransaction(signedTx.rawTransaction).then(receipt => {
			 			if (receipt.status) {
			 				console.log(receipt.transactionHash)
			 				resolve(receipt);
			 			} else {
			 				console.log("this user already regiester");
			 				reject("this user already regiester");
			 			}
			 		}).catch(err => {
			 			reject(err);
			 		});
				});
			});
		});	 	
}




