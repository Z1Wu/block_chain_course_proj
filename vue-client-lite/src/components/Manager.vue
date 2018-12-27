<template>
  <v-app id="inspire">
    <v-btn absolute dark fab right color="pink" @click="refresh">
        <v-icon>refresh</v-icon>
    </v-btn>
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
      // 当前游戏的密码
      final_ans: 0,
      valid: false,
      running: false,
      submitting: false,
      // 当前游戏的结果
      winning_number: "",
      winning_number_rule: [
        v => !!v || "Name is required",
        v => /[0-9]+/.test(v) || "require number"
      ]
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
      // onclock listener
      console.log("create a new game... ");
      let res = await this.contract.methods
        .new_game()
        .send({ from: this.account });
      console.log("successfully create a new game!!", res);
    },

    submit: async function() {
      console.log("summitting...");
      if (this.$refs.form.validate()) {
        // let have_game = await
        let res = await this.contract.methods
          .run_lottery(parseInt(this.winning_number))
          .send();
        console.log(res);
      }
    },

    refresh: async function() {
      // update all state from server
      // 更新当前游戏的轮数
      this.update_round_num();
      // 更新游戏的状态
      this.update_game_state();
      // 
    },

    update_round_num: async function() {
      console.log("update round num from node...");
      this.round_num = await this.contract.methods.round_num().call();
      console.log("update 'round number' from node successfully!!!");
    },

    update_game_state: async function() {
      console.log("update game state from node...");
      this.running = await this.contract.methods.hasGameRunning().call();
      console.log("update 'game state' from node successfully!!!");
    }
  }
};
</script>
