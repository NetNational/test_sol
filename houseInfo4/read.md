# House-0.1说明

1、HouseInfo包含了房东发布房源信息的基本要素，受限于EVM字节限制，所有将HouseInfo拆分为两部分，一部分为房源的基本信息，另外一部分为房源发布相关信息，以房源id为索引。

2、房东和租客都要交押金，防止一方毁约。

## House-0.2 说明

1、合约能够正常发布，缺少评论和合同相关的功能。

## House-0.3 说明

1、增加评论和合同相关功能模块

2、微调租房流程

## House-0.4 说明

1、合并Token合约与HouseInfo合约

2、调整房源信息中不合理的字段

## House-0.4-1说明

1、调整房东发布房源流程：房东先向合约转入保证金Token，然后才能发布房源。（HouseInfo合约具有管理Token的功能，但是实例化的token使用transfer函数必须是HouseInfo合约中的token转到用户的地址）

## House-0.4-3 说明

1、签订合同流程调整：房东发布房源后，租客请求租赁；房东调用签订协议方法租房协议，租客签订租房协议，租赁进入renting状态。

House-0.4.4

1、增加惩罚机制

2、分模块设计

3、修复bug，字节溢出

address anthor = l2rMaps[sender];
bonds[_houseId][anthor] = bonds[_houseId][anthor] - amount;

## House-0.4.5说明

1、优化变量，减少public变量

2、增加自动发放奖励

## House-1.0 说明

1、代码优化，使用ABI方式调用register和token模块，而不是直接通过代码调用，优化代码结构
2、增加登录验证，只有当用户登录后才能发布和签约

House-1.9 说明

1、调整一个地址对应一个houseId，一个houseId对应一条记录。将房源认证生成的houseId作为该房屋的唯一链上标识，房源发布时生成的id作为该笔房源交易的id，作为后续跟踪该房源的索引

2、调整requestSign中的相关判断，采用modifier判断。

3、调整login中require的判断，采用modifier替代。
