<template>
  <v-card id="WorkingtimeDonutChart" elevation="5">
    <v-fab-transition>
      <v-btn
        @click="refreshDonut"
        v-show="user"
        color="primary"
        text
        small
        absolute
        top
        right
      >
        <v-icon small>mdi-refresh</v-icon>Refresh
      </v-btn>
    </v-fab-transition>
    <v-card-title>Donut Workingtimes</v-card-title>
    <v-card-subtitle>
      <div>Chart of your working times</div>
      <div>Period: {{ sunday }} - {{ saturday }}</div>
    </v-card-subtitle>
    <div v-if="user">
      <v-container>
        <v-row>
          <v-col>
            <h2 v-if="todayDonutData.length > 0">Today (hours)</h2>
            <DonutChart
              id="todayDonut"
              :data="todayDonutData"
              colors='[ "#36A2EB", "gray" ]'
              resize="true"
              style="min-width: 250px; width: 50%; margin: 0 auto"
            >
            </DonutChart>
          </v-col>
          <v-col>
            <h2>Weekly (hours)</h2>
            <DonutChart
              id="weeklyDonut"
              :data="weeklyDonutData"
              colors='[ "#36A2EB", "gray" ]'
              resize="true"
              style="min-width: 250px; width: 50%; margin: 0 auto"
              :select="0"
            >
            </DonutChart>
          </v-col>
        </v-row>
      </v-container>
    </div>
    <v-card-text v-else>Please select an user !</v-card-text>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import { DonutChart } from "vue-morris";
import axios from "axios";
import moment from "moment";

export default {
  name: "ChartManager",
  components: { DonutChart },
  props: {
    user: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      todayDonutData: [],
      weeklyDonutData: [],
      sunday: null,
      saturday: null,
    };
  },
  computed: {
    ...mapGetters(["token", "notif"]),
  },
  mounted() {
    this.user && this.refreshDonut();
    this.getWeek();
  },
  methods: {
    refreshDonut() {
      axios({
        method: "get",
        url: `${process.env.VUE_APP_API_URL}/api/workingtimes/${this.user.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          this.workingTimes = res.data.data;
          const { data } = res.data;
          const todayDate = moment().format("YYYY MM DD");
          let workedToday = 0;
          let workedWeekly = 0;
          var curr = new Date();
          var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
          var lastday = new Date(
            curr.setDate(curr.getDate() - curr.getDay() + 6)
          );
          data.forEach(element => {
            const end = moment(element.end);
            const start = moment(element.start);
            const elemStartDay = start.format("YYYY MM DD");
            const elemEndDay = end.format("YYYY MM DD");
            if (elemEndDay === elemStartDay && elemEndDay === todayDate) {
              const duration = moment.duration(end.diff(start));
              const hours = parseInt(duration.asHours());
              workedToday += hours;
            }
            if (
              Date.parse(element.start) >= firstday.getTime() &&
              Date.parse(element.end) <= lastday.getTime() &&
              element.end != undefined
            ) {
              const duration = moment.duration(end.diff(start));
              const hours = parseInt(duration.asHours());
              workedWeekly += hours;
            }
          });

          this.todayDonutData = [
            { label: "Time worked(h)", value: workedToday },
            { label: "Time off(h)", value: 12 - workedToday },
          ];
          this.weeklyDonutData = [
            { label: "Time worked(h)", value: workedWeekly },
            { label: "Time off(h)", value: 60 - workedWeekly },
          ];
        })
        .catch(err => {
          throw err;
        });
    },
    getWeek() {
      var curr = new Date();
      var firstday = new Date(curr.setDate(curr.getDate() - curr.getDay()));
      var lastday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 6));
      this.sunday = firstday.toLocaleDateString("en-UK");
      this.saturday = lastday.toLocaleDateString("en-UK");
    },
  },
  watch: {
    user: function () {
      this.user && this.refreshDonut();
    },
    notif: function () {
      if (
        this.notif.text === "Good work !" ||
        this.notif.text === "Workingtime deleted !" ||
        this.notif.text === "Workingtime updated !"
      )
        this.refreshDonut();
    },
  },
};
</script>

<style lang="scss">
#WorkingtimeDonutChart {
  width: 100%;
  margin-top: 2rem;
  h2 {
    text-align: center;
  }
}
</style>
