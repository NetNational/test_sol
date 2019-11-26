let getContract = require("./common/contract_com.js").GetContract;
let  filePath = "./ethererscan/register.json";
let contractAddress = "0x26f6b5a796fe93bf9820b1aeba2786cd3cc975b9";
let web3 = require("./common/contract_com.js").web3;
// let AbiCoder = require("web3-eth-abi");
let Web3EthAbi = require('web3-eth-abi');
let comCos = require("./common/globe.js");
let nonceMap = new Map();

async function initReg() {
	let contract = await getContract(filePath, contractAddress);
	return contract;
}

// initReg().then(con => {
// 	// console.log(con.methods)
// 	let addr = "0xaDCe9984d4d2E3936A0eB6F21a6105217a3E8766";
// 	// isExitUserAddress(con, addr).then(res => {
// 	// 	console.log(res)
// 	// });
// 	let priKey = "0x36923250A8BF14292202A7932DA90A3222560E8FF3C0426FC6B6199F1EE29023";
// 	let username = "zs";
// 	let pwd = "123";
// 	let addr2 = "0x5b0ccb1c93064Eb8Fd695a60497240efd94A44ed";
// 	let priKey2 = "0x502D29356356AE02B7E23ECC851CCA0F21FE9CDADEF1FBAB158EB82611F27229";
// 	let username2 = "ym";
	// let addr4 = "0x8E0f4A1f3C0DBEA0C73684B49aE4AD02789B3EC4";
	// let priKey4 = "0xFFE962244D80F95197089FE5FF87BE0163D485E7986A7070A498136012FD7B61";
	// let username4 = "login";
	// let pwd = "pwd";
	// login(con, priKey4, addr4, username4, pwd).then((res, rej) => {
	// 	console.log(4343, res);
	// 	isLogin(con, addr4).then(res => {
	// 		console.log("isLogin", 444, res)
	// 		getFalg(con).then(res => {

	// 		})
	// 	});
	// });
// 	let addr3 = "0x7c943AAd08FE4FAC036FD8185Db145ae88dE1bb3";
// 	let priKey3 = "0x052719F3BB83E6081F064CBF4A2087067CD55F088404D0A20DB5CDCB075D867B";
// 	let username3 = "ym2"; 
// 	// login(con, priKey3, addr3, username3, pwd).then((res, rej) => {
// 	// 	console.log(4343, res);
// 	// 	isLogin(con, addr3).then(res => {
// 	// 		console.log("isLogin", 444, res)
// 	// 		getFalg(con).then(res => {

// 	// 		})
// 	// 	});
// 	// });
// 	// logout(con, priKey, addr, username, pwd).then((res, rej) => {
// 	// 	console.log(res);
// 	// });
// 	// findUserInfo(con, addr).then(res => {
// 	// 	console.log(res);
// 	// })
// 	// let addr3 = "0x7c943AAd08FE4FAC036FD8185Db145ae88dE1bb3";
// 	// getFalg(con).then(res => {

// 	// })
// 	// isLogin(con, addr3).then(res => {
// 	// 	console.log("isLogin", 444, res)
// 	// 	getFalg(con).then(res => {

// 	// 	})
// 	// });
// });
function getFalg(contract) {
	return new Promise(resolve => {
		contract.methods.getFlag1().call().then(res => {
			console.log("flag", res)
		})
	})
}


function isAlreayReg(contract, addr, username) {
	return new Promise(resolve => {
  	    contract.methods.isAlreayReg(addr, username).call().then(res => {
			if (res) {
				console.log("this user already exist");
				resolve(res);
			} else {
				resolve(false);
			}
		}).catch(err => {
				console.log(err)
		});
    });
}

function isExitUserAddress(contract, addr) {
	return new Promise(resolve => {
  	    contract.methods.isExitUserAddress(addr).call().then(res => {
			if (res) {
				console.log("this user already exist");
				resolve(res);
			} else {
				resolve(false);
			}
		}).catch(err => {
				console.log(err)
		});
    });
}
function isLogin(contract, addr) {
	return new Promise((resolve, reject) => {
		contract.methods.isLogin(addr).call().then(res => {
			// console.log("res", res)
			if (res) {
				resolve(res);
			} else {
				resolve(false);
			}
		});
	});
}
// 免费注册链上用户
function createUser(contract, privateKey, addr, username, pwd) {
    return new Promise((resolve, reject) => {
    	console.log("create user", addr)
        contract.methods.isExitUserAddress(addr).call().then(res => {
          console.log("user is existed or not !", res)
          if (!res) {
                const loginFun = contract.methods.createUser(addr, username, pwd);
                const logABI = loginFun.encodeABI();
                packSendMsg(comCos.regAddr, comCos.regpri, contractAddress, logABI).then(receipt => {                        
                    console.log("rece", receipt)
                    resolve(decodeLog(receipt, 'CreateUser'));
                    // if (receipt) {
                    //     console.log("Create the user success");
                    //     const eventJsonInterface = contract._jsonInterface.find(
                    //       o => (o.name === 'CreateUser') && o.type === 'event');
                    //     if (JSON.stringify(receipt.logs) != '[]') {
                    //       const log = receipt.logs.find(
                    //         l => l.topics.includes(eventJsonInterface.signature)
                    //       );
                    //       let decodeLog = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
                    //         console.log(decodeLog)
                    //         resolve(receipt);
                    //     } else {
                    //       resolve(false);
                    //     }
                    // }  else {
                    //   resolve(false);
                    // }              
                }).catch(err => {
                  console.log(222111)
                  reject(err);
                  console.log(22333)
                });
          } else {
              resolve("This address or user name already register");
          };
        });
   });
}

function decodeLog(receipt, eventName) {
	const eventJsonInterface = contract._jsonInterface.find(
      o => (o.name === eventName) && o.type === 'event');
    if (JSON.stringify(receipt.logs) != '[]') {
      const log = receipt.logs.find(
        l => l.topics.includes(eventJsonInterface.signature)
      );
      let decodeLog = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
        console.log(decodeLog)
        return receipt;
    } else {
      return false;
    }
}
// First, judge whether user register
// If user already register, login directly
// Or, the user must login firstly.
function login(contract, privateKey, addr, username, pwd) {
	return new Promise((resolve, reject) => {
  	    contract.methods.isExitUserAddress(addr).call().then(res => {
			if (res) {
				// console.log("Find:", res);
				const loginFun = contract.methods.login(addr, username, pwd);
		        const logABI = loginFun.encodeABI();
		        packSendMsg(addr, privateKey, contractAddress, logABI).then(receipt => {        			        	
		        	if (receipt) {
		        		console.log("Login success");
		        		const eventJsonInterface = contract._jsonInterface.find(
							o => (o.name === 'LoginEvent') && o.type === 'event');
						if (JSON.stringify(receipt.logs) != '[]') {
							const log = receipt.logs.find(
								l => l.topics.includes(eventJsonInterface.signature)
							)
							let decodeLog = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
			   				console.log(decodeLog)
			   				resolve(decodeLog);
						} else {
							resolve(false);
						}
		        	}  else {
						resolve(false);
					}
					
				}).catch(err => {
					console.log("Already login in");
					reject(err);
				});
			} else {
				console.log("Not find the user,it will directly create the user!");
				const createFunc = contract.methods.createUser(addr, username, pwd);
				const createABI = createFunc.encodeABI();
				packSendMsg(addr, privateKey, contractAddress, createABI).then((receipt, rej) => {
					console.log("Success create the user");
					if (receipt.status) {
						const loginFun = contract.methods.login(addr, username, pwd);
				        const logABI = loginFun.encodeABI();
				        packSendMsg(addr, privateKey, contractAddress, logABI).then(receipt => {        			        	
				        	if (receipt) {
				        		console.log("Login success");
				        		const eventJsonInterface = contract._jsonInterface.find(
									o => (o.name === 'LoginEvent') && o.type === 'event');
								if (JSON.stringify(receipt.logs) != '[]') {
									const log = receipt.logs.find(
										l => l.topics.includes(eventJsonInterface.signature)
									)
									let decodeLog = Web3EthAbi.decodeLog(eventJsonInterface.inputs, log.data, log.topics.slice(1))
					   				console.log(decodeLog)
					   				resolve(decodeLog);
								} else {
									resolve(false);
								}
				        	}  else {
								resolve(false);
							}
							
						}).catch(err => {
							console.log("Already login in");
							reject(err);
						});
					} else {
						reject(rej);
					}
				});				
			}
		});
    });
}

function findUserInfo(contract, addr) {
	return new Promise((resolve, reject) => {
		contract.methods.findUser(addr).call().then(res => {
			resolve(res);
		})
	})
}

function logout(contract, privateKey, addr, username, pwd) {
	return new Promise((resolve, reject) => {
  	    contract.methods.isLogin(addr).call().then(res => {
			if (res) {
				console.log("Find the user", res);
				const loginFun = contract.methods.logout(addr, username, pwd);
		        const logABI = loginFun.encodeABI();
		        packSendMsg(addr, privateKey, contractAddress, logABI).then(receipt => {        	
		        	if (receipt) {
		        		console.log("Login out success");
		        		resolve(receipt);
		        	} 
				}).catch(err => {
					console.log("Already login out");
					reject(err);
				});
			} else {
				reject("this user doesn't sign in!");			
			}
		});
    });
}

function packSendMsg(formAddr, privateKey, toAddr, createABI) {
		let gas, nonce;
		return new Promise((resolve, reject) => {
			gas = 20000000000;
			web3.eth.getTransactionCount(formAddr, 'pending').then(_nonce => {
				if (nonceMap.has(_nonce)) {
					_nonce += 1
				}
				nonceMap.set(_nonce, true);
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

module.exports = {
	initReg,
	isAlreayReg,
	isExitUserAddress,
	isLogin,
	login,
	logout,
	createUser
}