<template>
  <div name="app" ma-0 pa-0>
    <Manager
      :web3="web3"
      :contract="contract"
      :account="account"
      :jackpot="jackpot"
      :running="running"
      @update_state="refresh"
      :round_num="round_num"
      v-if="mode === 'MANAGER'"
    />
    <Player 
      :web3="web3" 
      :contract="contract" 
      :account="account"
      :running="running"
      :jackpot="jackpot"
      :round_num="round_num"
      @update_state="refresh"
      v-if="mode === 'PLAYER'"/>

    <Recipient 
      :web3="web3" 
      :contract="contract" 
      :account="account" 
      v-if="mode === 'RECEIPIENT'"/>

    <v-footer absolute color="cyan">
      <v-btn cyan fab fixed bottom right :loading="refreshing" @click="refresh">
        <v-icon>refresh</v-icon>
      </v-btn>
      <v-layout align-center justify-space-around wrap>
        <v-spacer></v-spacer>

        <v-flex flat round>已经进行的游戏轮数： {{round_num}}</v-flex>

        <v-flex flat round>游戏当前状态: {{game_state}}</v-flex>

        <v-flex flat round>当前奖池: {{jackpot}} wei</v-flex>
        <v-spacer></v-spacer>
      </v-layout>
    </v-footer>
  </div>
</template>

<script>
import LotteryContract from "./contracts/Lottery.json";
import getWeb3 from "./utils/getWeb3.js";
import Manager from "./components/Manager.vue";
import Player from "./components/Player.vue";
import Recipient from "./components/Recipient.vue";

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
      jackpot: "",

      refreshing: false,
    };
  },
  computed: {
    game_state: function() {
      return this.running ? "正在运行" : "无运行中游戏";
    }
  },

  components: {
    // HelloWorld,
    Manager,
    Player,
    Recipient
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

      const is_receipient =
        (await instance.methods
          .registered_people_in_need(this.account)
          .call()) > 0;

      console.log("is_receipient : ", is_receipient);

      if (this.account === manager) {
        this.mode = "MANAGER";
      } else if (is_receipient) {
        this.mode = "RECEIPIENT";
      } else {
        this.mode = "PLAYER";
      }

      await this.refresh();
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
      
      this.refreshing = true
      await this.update_round_num();
      // 更新游戏的状态
      await this.update_game_state();
      // 更新奖池
      await this.update_jackpot();
      this.refreshing = false
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
      // this.jackpot = web3.utils.fromWei
      console.log("update '[jackpot]' from node successfully!!!");
    }
  }
};
</script>

<style scoped>
#lateral .v-speed-dial,
#lateral .v-btn--floating {
  position: absolute;
}
#lateral .v-btn--floating {
  margin: 0 0 16px 16px;
}
</style>

