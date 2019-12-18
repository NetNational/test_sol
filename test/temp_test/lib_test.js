let bal = "100000001";
let temp = bal.slice(0, -6);
console.log("after splice balance", temp)
let newBal = parseFloat(temp);
console.log("After parese value", newBal);