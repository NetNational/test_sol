let getContract = require("./common/contract_com.js").GetContract;
let  filePath = "./ethererscan/token_abi.json";
let contractAddress = "0xfed21ab2993faa0e0b2ab92752428d96370d4889";
let web3 = require("./common/contract_com.js").web3;
let nonceMap = new Map();

async function initToken() {
  let contract = await getContract(filePath, contractAddress);
  return contract;
}

function getBalance(contract, addr) {
  return new Promise((resolve, reject) => {
    contract.methods.balanceOf(addr).call().then(res => {
      // console.log(res);
      resolve(res)
    }).catch(err => {
      console.log(err);
    });
  });
}
/**
* des: initAddr: 若是普通转账则与from相同；若是授权后的转账，则与from不同 
*/
initToken().then(con => {
   let from = "0x16c0b9cb893BA4392131df01e70F831A07d02687";

   let addr3 = "0x5b0ccb1c93064Eb8Fd695a60497240efd94A44ed";
   let privKey3 = "0x502D29356356AE02B7E23ECC851CCA0F21FE9CDADEF1FBAB158EB82611F27229";
   
   transfer(con, addr3, privKey3, from, addr3, 200000000).then((receipt, reject) => {
     console.log(receipt.transactionHash)
   });
});

function transfer(contract, initAddr, privateKey, from, to, amount) {
  return new Promise((resolve, reject) => {
      // console.log(contract.methods)
      const transFun = contract.methods.transferFrom(from, to, amount);
      const transABI = transFun.encodeABI();
      let gas, nonce;
      gas = 20000000000;
      web3.eth.getTransactionCount(initAddr, 'pending').then(_nonce => {
          if (nonceMap.has(initAddr) && (nonceMap[initAddr] == _nonce)) {
             _nonce += 1
          }
          nonceMap.set(initAddr, _nonce);
          nonce = _nonce.toString(16);
          const txParams = {
              gasPrice: gas,
              gasLimit: 210000,
              to: contractAddress,
              data: transABI,
              from: initAddr,
              chainId: 3,
              // value: web3.utils.toHex(amount),
              nonce: '0x' + nonce
          }
          web3.eth.accounts.signTransaction(txParams, privateKey).then(signedTx => {
              web3.eth.sendSignedTransaction(signedTx.rawTransaction).then(receipt => {
                // console.log(receipt)
                if (receipt.status) {
                  resolve(receipt);
                    // console.log(receipt.transactionHash)
                } else {
                  reject(receipt);
                }
              }).catch(err => {
                console.log(err);
              });
          });  
      });      
  });
}
// Call one for every contract
function approveTransfer(contract, from, privateKey,spender, amount) {
  return new Promise((resolve, reject) => {
      // console.log(contract.methods)
      const transFun = contract.methods.approve(spender, amount);
      const transABI = transFun.encodeABI();
      packSendMsg(from, privateKey, spender, transABI).then((res, rej)=> {
         resolve(res);
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
              // console.log(receipt.transactionHash)
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
    initToken,
    getBalance,
    transfer,
    approveTransfer
}
