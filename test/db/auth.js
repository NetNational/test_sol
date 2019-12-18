// 插入发布房屋信息
function insertApproRecord(conn, leaser_addr, landlord_addr, house_id) {
	console.log("-------insertApproRecord---------", house_id);
	return new Promise((resolve, reject) => {
		conn.then(con => {
			con.query("SELECT * FROM house_approve_record WHERE landlord_addr = ? and house_id = ? ", [landlord_addr, house_id],  function (err, result, fields) {
			    if (err) {
			    	console.log("--auth insert query error:", err);
			    	resolve({status: 203, err: err})
			    }
			    console.log(result)
			    if (result != null && result.length != 0) {
			    	resolve({status:201, data: result[0].addr});
			    } else {
			    	// 插入map表
					let insertSql = "INSERT INTO house_approve_record (`leaser_addr`, `landlord_addr`, `house_id`, `state`, `createtime`, `updatetime`) VALUES ?";
					let addParam = [[leaser_addr, landlord_addr, house_id, 0, Date.now(), Date.now()]]; // Mul
					con.query(insertSql, [addParam], function(err, result, fileds){
						console.log("--insert auth info-----",result);
						if (err) {
							console.log("auth insert error:", err);
							resolve({status:202, data:"该条授权记录已经发布过或者服务器繁忙！"});
						} else {
							resolve({status:200, data:result});
						}
					})
			    }
		    });
		}).catch(err => {
			console.log("---insert auth info----", err);
			reject(err);
		});
	});
}
// 查询房屋授权信息, houseId是房屋ID
function queryApprove(conn, houseId) {
	console.log("-------queryApprove---------", houseId, houseState)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			let sql, criteria;
			if (houseId == '0x') {
				sql = "SELECT * FROM house_approve_record WHERE house_id = ?";
				criteria = [*];
			} else {
				sql = "SELECT * FROM house_approve_record WHERE house_id = ?";
				criteria = [houseId];
			} 
			con.query(sql, criteria,  function(err, result, fields) {
			    if (err) {
			    	console.log("--auth insert query error:", err);
			    	resolve({status: false, err: err});
			    }
			    resolve({status: true, data: result});
		    });
		}).catch(err => {
			console.log("----query-auth--error---", err)
			reject(err);
		});
	});
}
// 更新发布房屋信息
function updateAuthInfo(conn, houseId, state) {
	console.log("-------update auth Info---------", userId, addr)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			con.query("UPDATE `house_approve_record` SET `house_state` = ?, `updatetime` = ? WHERE `house_id` = ?", [state, Date.now(), houseId], function(err, result, fileds){
				console.log("---update ---", result);
			});
			con.query("SELECT * FROM house_approve_record WHERE house_id = ? ", [houseId],  function (err, result, fields) {
			    if (err) {
			    	console.log("Query auth after update info" ,err);
			    	resolve({status: false, err: err});
			    }
			    if (result != null && result.length != 0) {
			    	resolve({status:true, data:result[0].addr});
			    } else {
			    	resolve({status: false, err: result});
			    }
		    });
		}).catch(err => {
			console.log("----query-auth--error---" ,err)
			reject(err);
		});
	});
}

module.exports = {
	queryApprove,
	insertApproRecord,
	updateAuthInfo
}