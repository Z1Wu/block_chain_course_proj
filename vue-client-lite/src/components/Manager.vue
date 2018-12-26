<template>
 <v-app id="inspire">
    <v-tabs
      centered
      color="cyan"
      dark
      icons-and-text
    >
      <v-tabs-slider color="yellow"></v-tabs-slider>
  
      <v-tab>
        开奖
        <v-icon>stars</v-icon>
      </v-tab>
  
      <v-tab>
        福利
        <v-icon>face</v-icon>
      </v-tab>

      <v-tab-item>
        <!-- <v-card flat>
          <v-card-text>Contents for Item 1 go here</v-card-text>
        </v-card> -->
        <HelloWorld/>
      </v-tab-item>
      
      <v-tab-item>
        <v-card flat>
          <v-card-text>Contents for Item 2 go here</v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs>
  </v-app>
</template>

<script>

import HelloWorld from "./HelloWorld.vue"

export default {
  name: 'Manager',
  // props: {
  //   "web3";
  // }
  components: {
    HelloWorld
  },
  data () {
    return {
      text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
    }
  },
}
</script>
