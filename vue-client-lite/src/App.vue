<template>
  <div name = 'app'>
    <!-- <HelloWorld/> -->
    <!-- <v-if " -->
    <Manager/>
  </div>
</template>

<script>

import LotteryContract from "./contracts/Lottery.json";
import getWeb3 from "./utils/getWeb3.js";
import Manager from "./components/Manager.vue"
// import HelloWorld from "./components/HelloWorld.vue"


export default {
  name: 'app',  
  data: () => {
    return {
      "web3": null,
      "contract": null,
      "mode": null,  
      "account": null
    }
  },
  components: {
    // HelloWorld,
    Manager,
  },
  created: async function(){
    console.log('abc')
      try {
      console.log("inside create hook")
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = LotteryContract.networks[networkId];
      const instance = new web3.eth.Contract(
        LotteryContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      console.log(web3, accounts)

      const manager = instance.methods.trusted_manager().call()
      // init data filed
      this.account = accounts[0]
      this.contract = instance
      this.web3 = web3

      if(accounts[0] === manager) {
        this.mode = "MANAGEG"
      } else {
        this.mode = "PLAYER"
      }
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  }
}
</script>
