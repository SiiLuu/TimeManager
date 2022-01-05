<template>
  <div id="dashboard">
    <v-row class="responsiveCol">
      <ClockManager :user="user" />
      <div class="WorkingtimesList">
        <Workingtimes :user="user" />
      </div>
    </v-row>
    <WorkingTimeDonutChart :user="user" />
    <WorkingtimesChart :user="user" />
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import Raphael from "raphael/raphael";
import ClockManager from "@/components/ClockManager.vue";
import Workingtimes from "@/components/Workingtimes.vue";
import WorkingTimeDonutChart from "@/components/WorkingTimeDonutChart.vue";
import WorkingtimesChart from "@/components/Workingtimes_chart.vue";
global.Raphael = Raphael;

export default {
  name: "Dashboard",
  components: {
    ClockManager,
    WorkingTimeDonutChart,
    WorkingtimesChart,
    Workingtimes,
  },
  computed: {
    ...mapGetters(["user"]),
  },
};
</script>

<style lang="scss" scoped>
#dashboard {
  width: 100%;
  margin-top: auto;
  margin-bottom: auto;

  .WorkingtimesList {
    margin-top: 2rem;
    margin-left: auto;
    margin-right: auto;
    width: 47.5%;
    height: 20rem;
    min-height: 20rem;
    max-height: 20rem;

    @media screen and (max-width: 430px) {
      width: 100%;
    }
  }

  @media screen and (max-width: 430px) {
    .responsiveCol {
      flex-direction: column;
    }
  }
}
</style>
