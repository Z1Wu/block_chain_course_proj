<template>
  <v-app id="palyer">
    <v-tabs centered color="cyan" dark icons-and-text>
      <v-tabs-slider color="yellow"></v-tabs-slider>
      <v-tab> 正在进行
        <v-icon>stars</v-icon>
      </v-tab>
      <v-tab> 往期结果查询
        <v-icon>face</v-icon>
      </v-tab>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-flex>
              <v-form ref="form" v-model="valid" lazy-validation>
                <v-text-field v-model="winning_number" label="投注号码" required></v-text-field>
                <v-btn :disabled="!betting && valid && !submitting" @click="bet"> BET </v-btn>
              </v-form>
            </v-flex>
          </v-layout>
        </v-container>
      </v-tab-item>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-form ref="search_filed" v-model="round_num_valid" lazy-validation>
                <v-text-field v-model="query_round_num" label="期数" required></v-text-field>
                <v-btn :disabled="!round_num_valid" @click="get_game_result"> search </v-btn>
              </v-form>
          </v-layout>
        </v-container>
      </v-tab-item>
    </v-tabs>
  </v-app>
</template>

<script>
export default {
  name: "Player",
  props: ["web3", "contract", "account", "running", "round_num", "jackpot"],
  data() {
    return {
      // 输入合法性
      valid: false,
      // 检测当前是否有游戏正在进行
      betting: false,
      submitting: false,
      // 当前游戏的结果
      winning_number: "",
      // 查询相关
      // 查询的轮数是否有效
      round_num_valid: false,
      // 查询的游戏期数
      query_round_num: "",
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
    // this.round_num = await this.contract.methods.round_num().call();
    // console.log("current round number: ", this.round_num);
  },

  methods: {
      bet: async function () {
        try {
            this.betting = true;
            console.log("betting...")
            let res = await this.contract.methods.bet(parseInt(this.winning_number)).send({from : this.account, value: this.web3.utils.toWei(1)});
            console.log("bet done", res);            
        } catch (error) {
            this.betting = false;
            alert("invalid betting, this ticket is taken by others")
        } finally {
            this.betting = false;
        }

      },

      get_game_result: async function () {
        // return game res of specific round # 
        try {
            // no need to be function
            let res = await this.contract.methods.all_games(this.round_num).call();
            console.log(res)
        } catch (error){
            console.log(error)
        }
      },
  
  }

};
</script>
