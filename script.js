// backend
//<imported from https://medium.com/coinmonks/web3-js-ethereum-javascript-api-72f7b22e2f0a
// imported https://piyopiyo.medium.com/how-to-convert-ether-from-wei-and-vice-versa-with-web3-1-0-0-3e3e691e3f0e
// imported from https://docs.metamask.io/wallet/how-to/send-transactions/
//const #ofitems =1; 

 async function initWeb3() { // working function as it already connects  
        if (window.ethereum) {
            window.web3 = new Web3(window.ethereum);
            await window.ethereum.enable();
            const accounts = await web3.eth.getAccounts();
            console.log(accounts[0])
         }
        else {
            console.log("wallet is not connected")
         }
    }

/*async function purchase(){ // draft code 
     if (window.ethereum){// if the function receive the signal from purchase commadmd
         window.web3 = window.ethereum.request(method: 'eth_sendTransaction', params:[accounts[0],accounts(),value()] )// sends the transaction {
         console.log(accounts[0]) // prints the purchase's balance 
           await amountofavailableitems // if the payment is successful
    
         } 
}
    function amountofavailableitems(){ // draft code
        if () { // the item is sold then decrease 
            #ofitems=-1
        }
          
            else{  // if the item is not sold, the quanity of the item remain constant 
                #ofitems = #ofitems;
            }
    }
function restock(){ //draft code 
    if (){//purchaser wants to restock
        const #ofitems =+1; //adds the amount the stocker want to increase quantity
    } 
}
*/

//function connecting(){
   // accountsbalance = web3.eth.getBalance(accounts[0]).fromWei;{
   //     console.log("Balance: ", accountsbalance);
  //  };

//}



//function transaction(){
   // web3.eth.getTransactionCount(web3.eth.accounts[0]);
//}


