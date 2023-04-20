//imported from https://www.dappuniversity.com/articles/web3-js-intro
//imported from https://www.newline.co/courses/intro-to-programming-ethereum-dapps/transferring-eth
App = {
  web3Provider: null,
  contracts: {},
  contractInstance: null,
  account: null,

  init: async function() {
    // initialize web3 provider
    if (typeof web3 !== 'undefined') {
      // Use Mist/MetaMask's provider
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Set the provider you want from Web3.providers
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545');
      web3 = new Web3(App.web3Provider);
    }

    $.getJSON('MyContract.json').then(async function(data) {
      var MyContractArtifact = data;
      App.contracts.MyContract = TruffleContract(MyContractArtifact);
      App.contracts.MyContract.setProvider(App.web3Provider);
      App.contractInstance = await App.contracts.MyContract.deployed();
    });

    // get current account
    App.account = web3.eth.accounts[0];
  },
 /*withdraw: asyn function() {
     
        var accesspoint = SmartCode.sol; // accessing smart contract
        var accesstraffic =accesspoint.data.deployed(); // accessing within the smart contract
        var token = accesstraffic.mintToken(){//accessing the mintToken to convert currency{
            var unconvertedtoken= web.eth.accounts[1].getBalance()// any account that person is on, who wants to convert the tokens from 
            const conversion = web3.utlis.fromWei(unconvertedtoken,'ether') // conversion rate 
            if (uncovertedtoken)> 0){
                var myconvertedtoken= web.eth.accounts[0] // accounts that needs the converted to as a last location
            } 
        }
     },
    async currentaccount() {
    console.log(currents[0]) // prints the current account if sucessful
    }
    async transfer(){
        web3.eth.sendTransaction(from:web3.eth.account[0],to: eth.accounts(), value: web3.toWei(3,"ether")); // from our current account to desired account
        
    }
async owneroftokenverification(){

}
}
*/
