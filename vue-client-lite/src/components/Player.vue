<template>
  <v-app id="palyer">
    <v-tabs centered color="cyan" dark icons-and-text>
      <v-tabs-slider color="yellow"></v-tabs-slider>
      <v-tab>正在进行
        <v-icon>stars</v-icon>
      </v-tab>
      <v-tab>往期结果查询
        <v-icon>face</v-icon>
      </v-tab>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-flex>
              <v-form ref="form" v-model="winning_num_valid" lazy-validation>
                <v-text-field
                  v-model="winning_number"
                  label="投注号码"
                  :rules="winning_number_rule"
                  required
                ></v-text-field>
                <v-btn :disabled="betting || !winning_num_valid" @click="bet">BET</v-btn>
              </v-form>
            </v-flex>
          </v-layout>
        </v-container>
      </v-tab-item>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-form ref="search_filed" v-model="round_num_valid" lazy-validation>
              <v-text-field
                v-model="query_round_num"
                label="期数"
                :rules="round_number_rule"
                required
              ></v-text-field>
              <v-btn 
              :disabled="!round_num_valid || searching" 
              @click="get_game_result"
              :loading="searching">search</v-btn>
            </v-form>

            <v-dialog v-model="show_search_res" hide-overlay persistent width="300">
              <v-card color="cyan">
                <v-card-text> 
                  <!-- <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear> -->
                  第 {{query_round_num}} 的开奖结果是 ； {{query_round_result}}
                </v-card-text>
                <v-btn depressed small
                  @click="show_search_res = false; searching = false">
                  close
                </v-btn>
              </v-card>
            </v-dialog>
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
      winning_num_valid: false,
      // 检测当前是否有游戏正在进行
      betting: false,
      searching: false,
      // 当前游戏的结果
      winning_number: "",
      // 查询相关
      // 查询的轮数是否有效
      round_num_valid: false,
      // 查询的游戏期数
      query_round_num: "",
      query_round_result: "",
      winning_number_rule: [
        v => !!v || "empty",
        v => !!/^[0-9]+$/.test(v) || "require number"
      ],
      round_number_rule: [
        v => !!v || "empty",
        v => !!/^[0-9]*$/.test(v) || "require number"
      ],

      show_search_res: false
    };
  },

  created: async function() {
    console.log(
      "inside manager component...",
      this.web3,
      this.account,
      this.contract
    );
  },

  methods: {
    bet: async function() {
      try {
        this.betting = true;
        console.log("betting...", this.winning_number);
        let res = await this.contract.methods.bet(this.winning_number).send({
          from: this.account,
          value: this.web3.utils.toWei("1", "ether")
        });
        console.log("bet done", res);
        // this.$emit()
      } catch (error) {
        this.betting = false;
        console.log(error);
        // alert("invalid betting, this ticket is taken by others")
      } finally {
        this.betting = false;
      }
    },

    get_game_result: async function() {
      // return game res of specific round #
      try {
        
        this.searching = true
        console.log(
          "searching...",
          this.query_round_num,
          typeof this.query_round_num
        );
        let res = await this.contract.methods
          .all_games(this.query_round_num)
          .call();
        // this.searching = false
        this.show_search_res = true
        console.log(res);
        this.query_round_result = res.res;
        // pop up a dialog here
      } catch (error) {
        console.log(error);
      }
    }
  }
};
</script>

