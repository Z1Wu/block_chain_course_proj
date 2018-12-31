<template>
  <v-app id="inspire">
    <v-tabs centered color="cyan" dark icons-and-text>
      <v-tabs-slider color="yellow"></v-tabs-slider>
      <v-tab>新游戏
        <v-icon>fiber_new</v-icon>
      </v-tab>
      <v-tab>开奖
        <v-icon>stars</v-icon>
      </v-tab>
      <v-tab>注册受助者
        <v-icon>face</v-icon>
      </v-tab>

      <v-tab-item>
        <v-container text-xs-center wrap mt-5>
          <v-layout align-center justify-center row fill-height>
            <v-flex>
              <v-card max-width>
                <v-card-title primary-title>
                <v-spacer></v-spacer>
                  <div>
                    <div class="headline">{{game_state}}</div>
                  </div>
                <v-spacer></v-spacer>
                </v-card-title>
                
                <v-card-actions >
                <v-spacer></v-spacer>
                  <v-btn
                    large
                    :loading="creating"
                    :disabled="running || creating"
                    color="blue-grey"
                    class="white--text"
                    @click="new_game"
                  >CREATE A NEW GAME
                    <v-icon right dark>cloud_upload</v-icon>
                  </v-btn>
                  <v-spacer></v-spacer>
                </v-card-actions>
              </v-card>
            </v-flex>
          </v-layout>
        </v-container>
      </v-tab-item>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-flex>
              <v-form ref="reveal_form" v-model="valid" lazy-validation>
                <v-text-field
                  v-model="winning_number"
                  label="中奖号码"
                  :rules="winning_number_rule"
                  required
                ></v-text-field>
                <v-btn 
                  :disabled=" !running || !valid || submitting"
                  :loading="submitting"                  
                  @click="reveal"
                  >REVEAL</v-btn>
              </v-form>
            </v-flex>
          </v-layout>
        </v-container>
      </v-tab-item>

      <v-tab-item>
        <v-container text-xs-center wrap>
          <v-layout align-space-around justify-center column fill-height>
            <v-form ref="new_recipient_form" v-model="recipient_valid" lazy-validation>
              <v-text-field
                v-model="recipient_addr"
                label="受助者钱包地址"
                :rules="recipient_addr_rule"
                required
              ></v-text-field>
              <v-text-field
                v-model="recipient_num"
                label="受助金额"
                :rules="recipient_num_rule"
                required
              ></v-text-field>
              <v-btn 
                :disabled="!recipient_valid" 
                :loading="adding"                
                @click="add_new_recipient"
                
                >add</v-btn>
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
  props: ["web3", "contract", "account", "running", "jackpot", "round_num"],
  data() {
    return {
      // 开奖相关的代码
      // 当前游戏的轮数
      valid: false,
      creating: false,
      submitting: false,
      // 当前游戏的结果
      winning_number: "",
      winning_number_rule: [
        v => !!v || "请输入中奖号码",
        // v => v.length() > 0 || "empty",
        v => !!/^[0-9]+$/.test(v) || "只能是数字"
      ],

      // 福利部份相关
      // 输入的受助者地址
      adding: false,
      recipient_valid: true,
      recipient: "",
      recipient_addr: "",
      recipient_num: "",
      recipient_num_rule: [
        v => parseInt(v) > 0 || "number must bigger than zero"
      ],
      recipient_addr_rule: [
        v => /^0x[0-9a-zA-Z]+$/.test(v) || "invalid format address"
      ]
    };
  },

  computed: {
    game_state: function() {
      return this.running
        ? "正在运行第 " + this.round_num + " 轮游戏，无法创建新游戏"
        : "当前没有正在运行的游戏";
    }
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
    new_game: async function() {
      // 创建一个新的游戏
      try {
        if (this.running || this.creating) {
          alert("can't creating a new game");
          return;
        }
        console.log("creating a new game... ");
        this.creating = true;
        let res = await this.contract.methods
          .new_game()
          .send({ from: this.account });
        console.log("successfully create a new game!!", res);
        this.creating = false;
        // update round number and other
        this.$emit("update_state")
      } catch (error) {
        console.log("error occur during creating a new game", error);
      }
    },

    reveal: async function() {
      console.log("revealing...");
      if (this.$refs.reveal_form.validate()) {
        if (this.running == false) {
          alert("当前没有正在运行的游戏");
          return;
        }

        try {
          this.submitting = true;
          let res = await this.contract.methods
            .run_lottery(this.winning_number)
            .send({
              from: this.account
            });
          this.submitting = false
          this.$emit("update_state")
          console.log("run_lottery : ", res)
        } catch (error) {
          console.log(error);
          this.submitting = false
        }
      }
    },

    // 添加福利相关的模块
    add_new_recipient: async function() {
      if (this.$refs.new_recipient_form.validate()) {
        try {
          this.adding = true;
          console.log("adding recipient...");
          let res = await this.contract.methods
            .add_or_update_amount(this.recipient_addr, this.recipient_num)
            .send({ from: this.account });
          console.log("add recipient successfully", res);
          alert("添加成功")
          this.$emit("update_state")          
        } catch (error) {
          console.log("fail to add", error);
        } finally {
          this.adding = false
        }
      }
    },

    // 查看受助者的状态
    get_recipient_state: async function() {
      let amount = await this.contract.methods
        .registered_people_in_need(this.recipient_addr)
        .call();
      console.log(amount);
      return amount;
    }
  }
};
</script>

