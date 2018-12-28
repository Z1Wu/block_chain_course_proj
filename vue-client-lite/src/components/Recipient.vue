<template>
  <v-app id="inspire">
    <v-btn absolute dark fab right color="pink" @click="refresh">
        <v-icon>refresh</v-icon>
    </v-btn>
    <v-tabs centered color="cyan" dark icons-and-text>
      <v-tabs-slider color="yellow"></v-tabs-slider>
      <v-tab>正在运行的游戏
        <v-icon>stars</v-icon>
      </v-tab>
      <v-tab>已经结束的游戏
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
              <v-btn :disabled="running" @click="new_game">NEW_GAME</v-btn>
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
            <v-form ref="new_rerecipient_form" v-model="address_valid" lazy-validation>
                <v-text-field v-model="recipient_addr" label="受助者钱包地址" required></v-text-field>
                <v-text-field v-model="recipient_num" label="受助金额" required></v-text-field>
                <v-btn :disabled="rerecipient_valid" @click="submit">add</v-btn>
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
      // 当前游戏的轮数
      round_num: -1,
      // 当前的奖池数目
      jackpot: -1,
      // 输入合法性
      valid: false,
      // 检测当前是否有游戏正在进行
      running: false,
      submitting: false,
      // 当前游戏的结果
      winning_number: "",
      winning_number_rule: [
        v => !!v || "Name is required",
        v => /[0-9]+/.test(v) || "require number"
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
  }
  
};
</script>
