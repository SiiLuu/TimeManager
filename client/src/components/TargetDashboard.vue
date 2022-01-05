<template>
  <v-card id="targetDashboard">
    <v-toolbar color="primary" dark>
      <v-toolbar-title>{{ user.username }} dashboard</v-toolbar-title>
    </v-toolbar>
    <v-card-text class="content">
      <Workingtimes :user="user" />
      <WorkingTimeDonutChart :user="user" />
      <WorkingtimesChart :user="user" />
    </v-card-text>
  </v-card>
</template>

<script>
import Workingtimes from "@/components/Workingtimes.vue";
import WorkingTimeDonutChart from "@/components/WorkingTimeDonutChart.vue";
import WorkingtimesChart from "@/components/Workingtimes_chart.vue";

export default {
  name: "Dashboard",
  props: ["user"],
  components: {
    WorkingTimeDonutChart,
    WorkingtimesChart,
    Workingtimes,
  },
};
</script>

<style lang="scss" scoped>
#targetDashboard {
  .content {
    padding: 1.5rem;
  }
}
</style>
