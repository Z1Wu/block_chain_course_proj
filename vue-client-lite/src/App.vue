<template>
  <div name="app">
    <Manager :web3="web3" :contract="contract" :account="account" v-if="mode === 'MANAGER'"/>
    <Player :web3="web3" :contract="contract" :account="account" v-if="mode === 'PLAYER'"/>

    <!-- 添加游戏状态栏，as footer -->
    <v-footer height="auto" color="primary lighten-1">
      <v-layout justify-center row wrap>
        <v-flex color="white" flat round>已经进行的游戏轮数： {{round_num}}</v-flex>

        <v-flex color="white" flat round>游戏当前状态: {{running}}</v-flex>

        <v-flex color="white" flat round>当前奖池: {{jackpot}}</v-flex>

        <v-btn absolute dark fab bottom right color="pink" @click="refresh">
          <v-icon>refresh</v-icon>
        </v-btn>
      </v-layout>
    </v-footer>
  </div>
</template>

<script>
import LotteryContract from "./contracts/Lottery.json";
import getWeb3 from "./utils/getWeb3.js";
import Manager from "./components/Manager.vue";
import Player from "./components/Player.vue";

export default {
  name: "app",
  data: () => {
    return {
      web3: null,
      contract: null,
      mode: "",
      account: null,
      running: false,
      round_num: "",
      jackpot: ""
    };
  },
  components: {
    // HelloWorld,
    Manager,
    Player
  },
  created: async function() {
    try {
      console.log("inside create hook");
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = LotteryContract.networks[networkId];
      const instance = new web3.eth.Contract(
        LotteryContract.abi,
        deployedNetwork && deployedNetwork.address
      );
      console.log(web3, accounts);
      const manager = await instance.methods.trusted_manager().call();
      // init data filed
      this.account = accounts[0];
      this.contract = instance;
      this.web3 = web3;

      if (accounts[0] === manager) {
        this.mode = "MANAGER";
      } else {
        this.mode = "PLAYER";
      }
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  },

  methods: {
    refresh: async function() {
      // update all state from server
      // 更新当前游戏的轮数
      this.update_round_num();
      // 更新游戏的状态
      this.update_game_state();
      // 更新奖池
      this.update_jackpot();
    },

    // 更新相关的状态
    update_round_num: async function() {
      console.log("update round num from node...");
      this.round_num = await this.contract.methods.round_num().call();
      console.log("update 'round number' from node successfully!!!");
    },

    update_game_state: async function() {
      console.log("update game state from node...");
      this.running = await this.contract.methods.hasGameRunning().call();
      console.log(
        "update 'game state' from node successfully!!!",
        this.running
      );
    },

    update_jackpot: async function() {
      console.log("update [jackpot] from node...");
      this.jackpot = await this.contract.methods.jackpot().call();
      console.log("update '[jackpot]' from node successfully!!!");
    }
  }
};
</script>
