<template>
  <div v-if="manager" id="ChartManager">
    <h1>Option Manager</h1>
    <v-container class="px-0" fluid>
      <v-switch v-model="switch1" :label="`Activer les graphismes`"></v-switch>
    </v-container>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "ChartManager",
  props: ["user"],
  components: {},
  data() {
    return {
      manager: null,
      switch1: true,
    };
  },
  computed: {},
  mounted() {
    this.user && this.getManager();
  },
  methods: {
    getManager() {
      axios
        .get(`${process.env.VUE_APP_API_URL}/api/chartManager/${this.user.id}`)
        .then(res => {
          console.log(res.data.data);
          this.manager = res.data.manager;
        });
    },
  },
  watch: {
    user: function () {
      this.getManager();
      console.log(this.manager);
    },
  },
};
</script>

<style lang="scss"></style>
