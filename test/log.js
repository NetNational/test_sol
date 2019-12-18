function approveVisit(db, contract, houseId, addr, approveAddr, arpprovePrikey) {
	return new Promise((resolve, reject) => {
		const loginFun = contract.methods.approveVisit(addr);
        const logABI = loginFun.encodeABI();
        packSendMsg(approveAddr, arpprovePrikey, contractAddress, logABI).then(receipt => {  
            console.log("Approve Vist callback: " ,receipt) 
			let [flag, ctx, sendMsg] = decodeLog(contract, receipt, 'ApproveVist');
            if (flag) {
            	console.log(sendMsg);
            	resolve({status:flag, data:ctx.transactionHash});
            } else {
            	resolve({status:false, err:"授权失败，请稍后重新授权！"});
            }  
		}).catch(err => {
			console.log("授权访问失败，请检查是房屋是否已经认证！");
			reject({status:false, data: err});
		});
    });
}