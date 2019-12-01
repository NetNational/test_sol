// 查询用户地址, userId是Phone Number
function insertUserAddress(conn, userId, addr) {
	console.log("-------insertUserAddress---------", userId)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			// 插入map表
			let insertSql = "INSERT INTO house_addr_map_user (`userid`, `addr`, `createtime`, `updatetime`) VALUES ?";
			let addParam = [[userId, addr, Date.now(), Date.now()]]; // Mul
			con.query(insertSql, [addParam], function(err, result, fileds){
				console.log("--insert map--user address-----",result);
				if (err) console.log(err);
				resolve({status:true, data:result});
			}).catch(err => {
				console.log("--insert map--user address error--", err)
				resolve({status:false, err: err});
			});
		}).catch(err => {
			console.log("---insert userid map address error----", err);
			reject(err);
		});
	});
}
// 查询用户地址, userId是Phone Number
function queryUserAddress(conn, userId) {
	console.log("-------queryUserAddress---------", userId)
	return new Promise((resolve, reject) => {
		conn.then(con => {
			con.query("SELECT * FROM house_addr_map_user WHERE userid = ? ", [userId],  function (err, result, fields) {
			    if (err) console.log(err);
			    if (result != null && result.length != 0) {
			    	resolve(result[0].addr);
			    } else {
			    	resolve(result);
			    }
		   }).catch(err => {
			 console.log("---query user map error----", err);
			 reject(err);
		   });
			con.release();
		}).catch(err => {
			console.log("----query---error---" ,err)
			reject(err);
		});
	});
}


module.exports = {
	queryUserAddress,
	insertUserAddress
}