<template>
  <v-card v-if="this.data" id="TeamChart" elevation="3">
    <v-fab-transition>
      <v-btn
        @click="refreshData"
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
    <v-card-title>Workingtime of the team</v-card-title>
    <v-card-text v-if="user">
      <line-chart
        v-if="this.data"
        id="line"
        v-bind:data="this.data"
        v-bind:ykeys="this.usernames"
        v-bind:labels="this.usernames"
        v-bind:line-colors="this.palette"
        hideHover="true"
        xLabels="day"
        xkey="date"
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
    </v-card-text>
    <v-card-text v-else>Please select an user !</v-card-text>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import axios from "axios";
import { LineChart } from "vue-morris";
import moment from "moment";

export default {
  components: {
    LineChart,
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
    ...mapGetters(["user", "token"]),
  },
  props: ["id_team"],
  data: function () {
    return {
      data_full: null,
      datelength: 14,
      palette: [
        "#FF0000",
        "#00429d",
        "#2b78b3",
        "#56aec9",
        "#81e4df",
        "#a3fec9",
        "#bdfb86",
        "#d6f843",
        "#ff9d89",
        "#ff5e78",
        "#ff1f67",
        "#f00059",
        "#d1004f",
        "#b20044",
        "#93003a",
      ],
      usernames: null,
    };
  },
  mounted() {
    this.refreshData();
  },
  methods: {
    refreshData: function () {
      axios({
        method: "get",
        url: `${process.env.VUE_APP_API_URL}/api/teams/${this.id_team}/workingtimes/`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          let localarray = [];

          let index_array = [];
          let user_array = ["average"];

          for (const idx in res.data.data) {
            let elem = res.data.data[idx];
            let date = elem.start.substring(0, elem.start.indexOf("T"));
            const temp = user_array.filter(user => user === elem.user);
            temp.length <= 0 && user_array.push(elem.user);
            if (localarray[index_array[date]] === undefined && elem.end) {
              let date1 = moment(elem.end);
              let date2 = moment(elem.start);

              index_array[date] = localarray.length;
              let newelem = { date: date };
              newelem[`${elem.user}`] = date1.diff(date2, "minutes") / 60;
              localarray.push(newelem);
            } else if (elem.end) {
              let date1 = moment(elem.end);
              let date2 = moment(elem.start);
              if (localarray[index_array[date]][elem.user] === undefined)
                localarray[index_array[date]][elem.user] = 0;

              localarray[index_array[date]][elem.user] +=
                date1.diff(date2, "minutes") / 60;
            }
          }
          if (localarray.length) {
            localarray.sort((a, b) => new Date(a.date) - new Date(b.date));
            let first_date = moment(localarray[0].date);
            let last_date = moment(localarray[localarray.length - 1].date);
            while (last_date.diff(first_date) >= 0) {
              if (index_array[first_date.format("YYYY-MM-DD")] === undefined) {
                index_array[first_date.format("YYYY-MM-DD")] =
                  localarray.length;
                let new_elem = {
                  date: first_date.format("YYYY-MM-DD"),
                };
                localarray.push(new_elem);
              }
              let average = 0;
              let index = index_array[first_date.format("YYYY-MM-DD")];
              for (const user in user_array) {
                const element = user_array[user];
                if (element !== "average") {
                  if (localarray[index][element] === undefined) {
                    localarray[index][element] = 0;
                  }
                  average += localarray[index][element];
                }
              }
              const nbUsers = user_array.length - 1;
              localarray[index]["average"] = average / nbUsers;
              first_date = first_date.add(1, "days");
            }
            localarray.sort((a, b) => new Date(a.date) - new Date(b.date));

            this.usernames = [...new Set(user_array)];
            this.data_full = localarray;
          }
        })
        .catch(err => {
          throw err;
        });
    },
  },
};
</script>

<style>
#TeamChart {
  width: 100%;
  margin-bottom: 1.5rem;
}
</style>
