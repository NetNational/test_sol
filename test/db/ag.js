// 房东签订合同记录表
function insertAgreeRecord(conn, userName, phoneNum, addr, houseAddr, rental, tenancy, txHash, houseId, falsify, houseDeadline, houseUse, payOne) {
	console.log("-------insertRealseInfo---------", phoneNum)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			con.query("SELECT * FROM house_transaction_record WHERE addr = ? ", [addr],  function (err, result, fields) {
			    if (err) {
			    	console.log("--release insert query error:", err);
			    	resolve({status: 203, err: err})
			    }
			    console.log(result)
			    if (result != null && result.length != 0) {
			    	resolve({status:201, data: result[0].addr});
			    } else {
			    	// 插入map表
			    	// userId, userName, addr, houseAddr, rental, tenacy, txHash, houseId, falsify, houseDeadline
			    	let state = 0;
					let insertSql = "INSERT INTO house_transaction_record (`username`, `userid`, `addr`, `house_addr`, `tenancy`, `rental`, `house_id`, `tx_hash`, `house_use`,`state`, `pay_deadline`, `pay_one`, `flsify_month`,`landlord_sign_time`,`createtime`, `updatetime`) VALUES ?";
					let addParam = [[userName, phoneNum, addr, houseAddr, tenancy, rental, houseId, txHash, houseUse, state, 3, payOne, falsify, Date.now(), Date.now(), Date.now()]]; // Mul
					con.query(insertSql, [addParam], function(err, result, fileds){
						console.log("--insert release info-----",result);
						if (err) {
							console.log("release insert error:", err);
							resolve({status:202, data:"该条房屋记录已经发布过或者服务器繁忙！"});
						} else {
							resolve({status:200, data:result});
						}
					})
			    }
		    });
		}).catch(err => {
			console.log("---insert release info----", err);
			reject(err);
		});
	});
}
// 查询房东签订信息
function querySignInfo(conn, houseId) {
	console.log("-------querySignInfo--------", houseId)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			let sql, criteria;
			if (!houseId || houseId == '0x') {
				sql = "SELECT * FROM house_transaction_record";
				criteria = [];
			} else {
				sql = "SELECT * FROM house_transaction_record WHERE `house_id` = ?";
				criteria = [houseId];
			} 
			con.query(sql, criteria,  function (err, result, fields) {
			    if (err) {
			    	console.log(err);
			    	resolve({status:false, err:err});
			    } else {
			    	resolve({status: true, data:result});
			    }
		    });
		}).catch(err => {
			console.log("----query-release--error---", err)
			reject(err);
		});
	});
}
function queryTenAndState() {
	return new Promise((resolve, reject) => {

	});
	con.query("SELECT * FROM house_transaction_record WHERE house_id = ?", [houseId],  function (err, res, fields) {
	    if (err) {
	    	console.log("Query house transaction record error" ,err);
	    	reject(err);
	    } else {
	    	let rent, tenancy;
	    	// console.log(res, res.data)
		    if (res && res.length == 1) {
		    	tenancy = res[0].tenancy;
		    } else if (res && res.length > 1) {
		    	tenancy = res.data[res.data.length].tenancy;
		    }
		    let startTime = Date.now();
		    let endTime = (startTime/1000 + tenancy*30*24*3600)*1000;
		    console.log(tenancy, endTime);
			
	    }
    });
}

// 更新签订合同信息
function updateAgreeRecord(conn, houseId, leaserName, leaserId, renewalMonth, breakMonth, leaserAddr) {
	console.log("-------update Agree Record---------", leaserId, leaserAddr);
	return new Promise((resolve, reject) => {
		conn.then(con => {
			let state = 1; // 合同状态为：已签订
			let agreeCopies = 2; // 合同份数
			let startTime = Date.now();
			con.query("SELECT * FROM house_transaction_record WHERE house_id = ?", [houseId],  function (err, result, fields) {
			    if (err) {
			    	console.log("Query house transaction record error" ,err);
			    	reject(err);
			    } else {
			    	let rent, tenancy;
				    if (result && result.data.length == 1) {
				    	tenancy = result.data.tenancy;
				    } else if (result && result.data.length > 1) {
				    	tenancy = result.data[result.data.length].tenancy;
				    }
				    let endTime = Date.now() + tenancy*30*24*3600;
					let sql = "UPDATE `house_transaction_record` SET `leaser_id` = ?, `leaser_addr` = ?, `state` = ?, `renewal_before_month` = ?, `notice_break_month` = ?, `rent_start_time` = ?, `rent_end_time` = ?,`agree_copies` = ?, `lease_sign_time` = ?, `updatetime` = ? WHERE `house_id` = ?";
					let condition = [leaserId, leaserAddr, state, renewalMonth, breakMonth, startTime, endTime, agreeCopies, Date.now(), Date.now(), houseId];
					con.query(sql, condition, function(err, result, fileds){
						console.log("---update ---", result);
					});
					con.query("SELECT * FROM house_transaction_record WHERE addr = ? ", [addr],  function (err, result, fields) {
					    if (err) {
					    	console.log("Query release after update info" ,err);
					    	reject(err);
					    }
					    resolve({status: true, err: result});
				    });
			    }
		    });
		}).catch(err => {
			console.log("----query-release--error---" ,err)
			reject(err);
		});
	});
}

function updateAgreeRecord(conn, houseId, leaserName, leaserId, renewalMonth, breakMonth, leaserAddr) {
	console.log("-------update Agree Record---------", leaserId, leaserAddr);
	return new Promise((resolve, reject) => {
		conn.then(con => {
			let state = 1; // 合同状态为：已签订
			let agreeCopies = 2; // 合同份数
			con.query("SELECT * FROM house_transaction_record WHERE house_id = ?", [houseId],  function (err, res, fields) {
			    if (err) {
			    	console.log("Query house transaction record error" ,err);
			    	reject(err);
			    } else {
			    	let rent, tenancy;
			    	console.log(res, res.data)
				    if (res && res.data && res.data.length == 1) {
				    	tenancy = res.data.tenancy;
				    } else if (res && res.data && res.data.length > 1) {
				    	tenancy = res.data[res.data.length].tenancy;
				    }
				    let startTime = Date.now();
				    let endTime = startTime + tenancy*30*24*3600;
					let sql = "UPDATE `house_transaction_record` SET `leaser_id` = ?, `leaser_addr` = ?, `state` = ?, `renewal_before_month` = ?, `notice_break_month` = ?, `rent_start_time` = ?, `rent_end_time` = ?,`agree_copies` = ?, `lease_sign_time` = ?, `updatetime` = ? WHERE `house_id` = ?";
					let condition = [leaserId, leaserAddr, state, renewalMonth, breakMonth, startTime, endTime, agreeCopies, Date.now(), Date.now(), houseId];
					con.query(sql, condition, function(err, result, fileds){
						console.log("---update ---", result);
					});
					con.query("SELECT * FROM house_transaction_record WHERE addr = ? ", [addr],  function (err, result, fields) {
					    if (err) {
					    	console.log("Query release after update info" ,err);
					    	reject(err);
					    }
					    resolve({status: true, err: result});
				    });
			    }
		    });
		}).catch(err => {
			console.log("----query-release--error---" ,err)
			reject(err);
		});
	});
}

// 更新签订合同信息
function updateAgreeState(conn, houseId, state) { 
	console.log("-------update Agree Record--state-------", leaserId, leaserAddr);
	return new Promise((resolve, reject) => {
		conn.then(con => {
			let sql = "UPDATE `house_transaction_record` SET `state` = ?, `updatetime` = ? WHERE `house_id` = ?";
			let condition = [state, houseId];
			con.query(sql, condition, function(err, result, fileds){
				console.log("---update ---", result);
			});
			con.query("SELECT * FROM house_transaction_record WHERE house_id = ? ", [houseId],  function (err, result, fields) {
			    if (err) {
			    	console.log("Query agreement record after update info" ,err);
			    	reject(err);
			    }
			    resolve({status: true, err: result});
		    });
		}).catch(err => {
			console.log("----query-agreement record--error---" ,err)
			reject(err);
		});
	});
}


module.exports = {
	insertAgreeRecord,
	updateAgreeRecord,
	querySignInfo
}