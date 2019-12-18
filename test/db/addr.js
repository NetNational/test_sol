
function updateUserStatus(conn, userId, addr, state) {
	console.log("-------update Release Info---------", userId, addr)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			con.query("UPDATE `house_addr_map_user` SET `status` = ?, `updatetime` = ? WHERE `addr` = ?", [state, Date.now(), addr], function(err, result, fileds){
				console.log("---update ---", result);
			});
			con.query("SELECT * FROM house_addr_map_user WHERE addr = ? ", [addr],  function (err, result, fields) {
			    if (err) {
			    	console.log("Query release after update info" ,err);
			    	reject(err);
			    }
			    if (result != null && result.length != 0) {
			    	resolve({status:true, data:result[0].addr});
			    } else {
			    	resolve({status: false, err: result});
			    }
		    });
		}).catch(err => {
			console.log("----query-release--error---" ,err)
			reject(err);
		});
	});
}

// 根据地址查询用户状态
function queryUserStatus(conn, addr) {
	console.log("-------queryUserAddress---------", addr)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			con.query("SELECT * FROM house_addr_map_user WHERE addr = ? ", [addr],  function (err, result, fields) {
			    if (err) {
			    	console.log(err);
			    	resolve({status: false, err:"该地址未绑定手机号，未查询到登录状态！"})
			    }
			    if (result != null && result.length != 0) {
			    	resolve({status:true, data:result[0].status});
			    } else {
			    	resolve({status: false, data: result});
			    }
		    });
			// con.release();
		}).catch(err => {
			console.log("----query---error---" ,err)
			reject(err);
		});
	});
}
