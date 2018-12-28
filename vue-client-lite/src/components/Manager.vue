<template>
  <v-app id="inspire">
    <v-tabs centered color="cyan" dark icons-and-text>
      <v-tabs-slider color="yellow"></v-tabs-slider>
      <v-tab>开奖
        <v-icon>stars</v-icon>
      </v-tab>
      <v-tab>福利
        <v-icon>face</v-icon>
      </v-tab>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-flex>
              <p>ROUND NUMBER: {{round_num}}</p>
            </v-flex>
            <v-flex>
              <p>JACKPOT NUMEBR: {{jackpot}}</p>
            </v-flex>
            <v-flex>
              <v-btn :disabled="!running && !creating" @click="new_game">NEW_GAME</v-btn>
            </v-flex>
            <v-flex>
              <v-form ref="form" v-model="valid" lazy-validation>
                <v-text-field v-model="winning_number" label="中奖号码" required></v-text-field>
                <v-btn :disabled="!running && valid && !submitting" @click="submit">REVEAL</v-btn>
              </v-form>
            </v-flex>
          </v-layout>
        </v-container>
      </v-tab-item>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-form ref="new_rerecipient_form" v-model="recipient_valid" lazy-validation>
                <v-text-field v-model="recipient_addr" label="受助者钱包地址" required></v-text-field>
                <v-text-field v-model="recipient_num" label="受助金额" required></v-text-field>
                <v-btn :disabled="!recipient_valid" @click="submit">add</v-btn>
              </v-form>
          </v-layout>
        </v-container>
      </v-tab-item>
    </v-tabs>
  </v-app>
</template>

<script>
export default {
  name: "Manager",
  props: ["web3", "contract", "account"],
  data() {
    return {
      
      // 开奖相关的代码
      // 当前游戏的轮数
      round_num: -1,
      // 当前的奖池数目
      jackpot: -1,
      // 输入合法性
      valid: false,
      // 检测当前是否有游戏正在进行
      running: false,
      creating: false,
      submitting: false,
      // 当前游戏的结果
      winning_number: "",
      winning_number_rule: [
        v => !!v || "Name is required",
        v => /[0-9]+/.test(v) || "require number"
      ],

      // 福利部份相关
      // 输入的受助者地址
      recipient_valid: true,
      recipient: "",
      recipient_addr: "",
      recipient_num: "",
      recipient_num_rule: [
        v => parseInt(v) > 0 || "number must bigger than zero",
      ],
      recipient_addr_rule:[
        v => /[0-9Xx]+/.test(v) || "invalid format address" 
      ],
    };
  },

  created: async function() {
    console.log(
      "inside manager component...",
      this.web3,
      this.account,
      this.contract
    );
    this.round_num = await this.contract.methods.round_num().call();
    console.log("current round number: ", this.round_num);
  },

  methods: {
    new_game: async function() {
      // 创建一个新的游戏
      console.log("create a new game... ");
      this.creating = true
      
      let res = await this.contract.methods
        .new_game()
        .send({ from: this.account });
      console.log("successfully create a new game!!", res)
      this.creating = false 
    },

    submit: async function() {
      console.log("summitting...");
      if (this.$refs.form.validate()) {
        this.submitting = true;
        let res = await this.contract.methods
          .run_lottery(parseInt(this.winning_number))
          .send();
        this.submitting = false; 
        console.log(res);
      }
    },

    refresh: async function() {
      // update all state from server
      // 更新当前游戏的轮数
      this.update_round_num();
      // 更新游戏的状态
      this.update_game_state();
      // 更新奖池
      this.update_jackpot()
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
      console.log("update 'game state' from node successfully!!!", this.running);
    },

    update_jackpot: async function() {
      console.log("update [jackpot] from node...");
      this.jackpot = await this.contract.methods.jackpot().call();
      console.log("update '[jackpot]' from node successfully!!!");
    },

    // 添加福利相关的模块
    add_new_recipient: async function() { 
      try {
        console.log("adding recipient...")
        let res = await this.contract.methods.add_or_update_amount(this.recipient_addr, parseInt(this.recipient_num)).send()
        console.log("add recipient successfully", res)
      } catch (error) {
        console.log("fail to add ")
      }
    },
    
    get_recipient_state: async function() {
      let amount = await this.contract.methods.registered_(this.recipient_addr)
      console.log(amount)
      return amount
    }
  
  }
};
</script>
