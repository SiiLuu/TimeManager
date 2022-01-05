<template>
  <v-card id="Workingtimes_chart" elevation="5">
    <v-fab-transition>
      <v-btn
        @click="getWorkingTimes_chart"
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
    <v-card-title>Lines Workingtimes</v-card-title>
    <v-card-subtitle>Chart of your working times</v-card-subtitle>
    <v-card-text v-if="user">
      <line-chart
        v-if="this.data"
        id="line"
        v-bind:data="this.data"
        xkey="date"
        ykeys='[ "duration" ]'
        bar-colors='[ "#36A2EB" ]'
        grid="true"
        grid-text-weight="bold"
        resize="true"
      >
      </line-chart>
      <v-slider
        v-if="data_full && data_full.length > 0"
        :max="data_full.length"
        min="1"
        thumb-label
        v-model="datelength"
      ></v-slider>
      <p v-else>No data</p>
    </v-card-text>
    <v-card-text v-else>Please select an user !</v-card-text>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import { LineChart } from "vue-morris";
import axios from "axios";
import moment from "moment";
moment().format("fr");

export default {
  name: "Workingtimes_chart",
  components: { LineChart },
  props: {
    user: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      data_full: null,
      datelength: 7,
    };
  },
  mounted() {
    this.user && this.getWorkingTimes_chart();
  },
  computed: {
    data: function () {
      if (this.data_full !== null) {
        return this.data_full.slice(
          this.data_full.length - this.datelength,
          this.data_full.length
        );
      } else {
        return null;
      }
    },
    ...mapGetters(["token", "notif"]),
  },
  methods: {
    getWorkingTimes_chart() {
      axios({
        method: "get",
        url: `${process.env.VUE_APP_API_URL}/api/workingtimes/${this.user.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          this.data_full = res.data.data;
          let localarray = [];
          let index_array = [];
          for (const idx in this.data_full) {
            let elem = this.data_full[idx];
            let date = elem.start.substring(0, elem.start.indexOf("T"));
            if (localarray[index_array[date]] === undefined && elem.end) {
              let date1 = moment(elem.end);
              let date2 = moment(elem.start);

              index_array[date] = localarray.length;
              localarray.push({
                date: date,
                user: elem.user,
                duration: date1.diff(date2, "minutes") / 60,
              });
            } else if (elem.end) {
              let date1 = moment(elem.end);
              let date2 = moment(elem.start);

              localarray[index_array[date]].duration +=
                date1.diff(date2, "minutes") / 60;
            }
          }
          if (localarray.length) {
            localarray.sort((a, b) => new Date(a.date) - new Date(b.date));
            let first_date = moment(localarray[0].date);
            let user = localarray[0].user;
            let last_date = moment(localarray[localarray.length - 1].date);
            while (last_date.diff(first_date) > 0) {
              if (index_array[first_date.format("YYYY-MM-DD")] === undefined) {
                let new_elem = {
                  date: first_date.format("YYYY-MM-DD"),
                  user: user,
                  duration: 0,
                };
                localarray.push(new_elem);
              }
              first_date = first_date.add(1, "days");
            }
            localarray.sort((a, b) => new Date(a.date) - new Date(b.date));
            this.data_full = localarray;
          }
        })
        .catch(err => {
          throw err;
        });
    },
  },
  watch: {
    user: function () {
      this.user && this.getWorkingTimes_chart();
    },
    notif: function () {
      if (
        this.notif.text === "Good work !" ||
        this.notif.text === "Workingtime deleted !" ||
        this.notif.text === "Workingtime updated !"
      )
        this.getWorkingTimes_chart();
    },
  },
};
</script>

<style lang="scss">
#Workingtimes_chart {
  margin-top: 2rem;
}
</style>
