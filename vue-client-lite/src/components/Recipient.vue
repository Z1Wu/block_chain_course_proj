<template>
  <v-app id="inspire">
    <v-card color="blue-grey darken-2" class="white--text">
      <v-card-title primary-title>可获取的补助: {{money}}</v-card-title>
    </v-card>

    <v-container text-xs-center wrap>
      <v-layout align-space-around justify-center column fill-height>
        <v-form ref="draw_relief_form" v-model="amount_valid" lazy-validation>
          <v-text-field v-model="drawing_amount" label="取出的金额" :rules="money_rule" required></v-text-field>
          <v-btn
            :disabled="drawing || !amount_valid"
            :loading="drawing"
            class="white--text"
            color="purple darken-2"
            @click="draw_relief"
          >获取</v-btn>
          <v-dialog v-model="drawing" hide-overlay persistent width="300">
            <v-card color="primary" dark>
              <v-card-text> 交易正在处理...
                <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear>
              </v-card-text>
            </v-card>
          </v-dialog>
        </v-form>
      </v-layout>
    </v-container>
  </v-app>
</template>

<script>
export default {
  name: "Manager",

  props: ["web3", "contract", "account"],

  data() {
    return {
      // 查询余额
      querying: true,
      // 取钱。。。
      drawing: false,

      // 当前余额
      money: "",

      // 需要提取出来金额
      drawing_amount: "",
      
      // 输入金额的有效性
      amount_valid: false,
    
      money_rule: [
        v => /^[^0]+[0-9]*$/.test(v) || "金额必须是正数"
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

    // get money from remote
    this.update_relief();
  },

  methods: {
    update_relief: async function() {
      try {
        console.log("query user relief ... ");
        this.money = await this.contract.methods
          .registered_people_in_need(this.account)
          .call();
        console.log("query done..", this.money);
      } catch (error) {
        console.log("fail to query", error);
      }
    },

    draw_relief: async function() {
      try {
        if(this.drawing_amount > this.money) {
          alert("余额不足")
          return
        }
        this.drawing = true;
        console.log("draw user relief ... ");
        this.money = await this.contract.methods
          .get_relief(this.drawing_amount)
          .send({ from: this.account });

      } catch (error) {
        console.log(" ", error);
      } finally {
        this.drawing = false;
        this.update_relief();
      }
    }
  }
};
</script>
