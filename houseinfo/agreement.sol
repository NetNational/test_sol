contract agreement {
	struct Agreement {
		string  leaser; // 出租方
		string  tenant; // 承租方
		string  houseAddress; // 房屋地址
		bytes32 describe; // 房屋描述  
		uint32  leaseTerm; //租赁期限
		uint256 startTime; // 租赁开始
		uint256 endTime; // 结束租赁时间
	}
	struct FeeAndClause {
		uint256 rent; // 每月租金
		uint256 yearRent; // 年租金
		uint256 payTime; // 每月租金交付时间
		bool    waterEleCharge; // 水电费用是否由乙方付
		uint8   waitTime; // 房屋修缮等待时间
		uint8   unpayTime; // 乙方不交付租金xx月以上可解除合同
		uint8   arrearsTime; // 乙方欠费xx月以上
	}
	struct OtherClause {
		uint8 copies; // 份数
		uint8 ownCopies; // 各拿份数
		string leaserSign; // 甲方签名
		string tenantSign; // 乙方签名
		uint256 leaserNumId; // 甲方身份证号
		uint256  tenantNumId; // 乙方身份证号
		uint256  leaserTel; // 甲方联系电话
		uint256  tenantTel; // 乙方联系电话
		uint256  leaserSignTime; // 甲方签订日期
		uint256  tenantSignTime; // 乙方签订日期 
	}
	/**
	 * dev rent house agreement
	 * Parm {_signer: sign the agreement, _houseId: the hash of the house,
	 * _mrental: rent the house cicyle, monthNum: how many money of rent the house}
	 */
	constructor(address _signer, byte32 _houseId, uint _mrental, uint monthNum){
		
	}

	
}