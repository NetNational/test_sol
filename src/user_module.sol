// 通过web3调用合约内的方法
function findOrCreate() {
	// let testAddr = "0x960bedf8df0a6e66b470ba560ee6fd1e0e32ee23";
	let testAddr = "0xc96CeD51346896c5dF44E40eE41CDBfb67AE6888";
	let contract = new web3.eth.Contract(abi, contractAddress, {gasPrice: '3000000', from: userAddr});
	let options = {
            from: testAddr, //创建账户用主账号
            gas: 8000000, //最大的gas数值
            gasPrice:"2100000" 
        }
	// let privateKey = "0x99d3a520b871ac67693da99db675d83e0944c73498e750a6a2ed50b54ec5be78";
	let privateKey = "0x5FCC55798BD426BA7683ED01DA9DB35A64B96FFE9EEE1549C6EF673494A39FAB";
	contract.methods.isExitUserAddress(testAddr).call().then(res => {
		console.log(res) 
		if (res) {
			console.log("this user already exist");
		} else {
			const createFunc = contract.methods.createUser(testAddr, "ym"); // it will be fail, if userAddr not in created user
			const createABI = createFunc.encodeABI()
			let gas, nonce;
			web3.eth.getBalance(testAddr).then(console.log)
				gas = 20000000000;
				web3.eth.getTransactionCount(testAddr, 'pending').then(_nonce => {
					if (nonceMap.has(_nonce)) {
						_nonce += 1
					}
					nonceMap.set(_nonce, true);
					// console.log(_nonce)
					nonce = _nonce.toString(16);
					const txParams = {
					  gasPrice: gas,
				      gasLimit: 2000000,
				      to: contractAddress,
				      data: createABI,
				      from: testAddr,
				      chainId: 3,
				      nonce: '0x' + nonce
					}
				 	web3.eth.accounts.signTransaction(txParams, privateKey).then(signedTx => {
				 		// console.log(signedTx)
				 		web3.eth.sendSignedTransaction(signedTx.rawTransaction).then(receipt => {
				 			console.log(receipt)
				 			if (receipt.status) {
				 				console.log(receipt.transactionHash)
				 			} else {
				 				console.log("this user already regiester");
				 			}
				 		}).catch(err => {
				 			console.log(err)
				 	})
				})
		  			
			});
		}
	}).catch(err => {
				console.log(err)
	})
}