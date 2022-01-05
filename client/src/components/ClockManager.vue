<template>
  <v-card id="ClockManager" elevation="5">
    <v-card-title>Clock Manager</v-card-title>
    <v-card-subtitle v-if="!user"> You can active clock here !</v-card-subtitle>
    <v-card-subtitle v-else-if="workingTimeId">
      Working since :
      {{ this.workingSince }}
    </v-card-subtitle>
    <v-card-subtitle v-else> Not actually working </v-card-subtitle>
    <v-card-text v-if="user">
      <v-btn
        @click="clock"
        :disabled="workingTimeId ? true : false"
        color="primary"
        elevation="5"
        x-large
      >
        ClockIn
      </v-btn>
      <v-btn
        @click="clockOut"
        :disabled="!workingTimeId ? true : false"
        color="success"
        elevation="5"
        x-large
      >
        ClockOut
      </v-btn>
    </v-card-text>
    <v-card-text v-else> Please select an user ! </v-card-text>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import axios from "axios";
import moment from "moment";

export default {
  name: "ClockManager",
  props: {
    user: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      startDateTime: null,
      clockIn: false,
      workingSince: null,
      workingTimeId: null,
      refreshInterval: null,
    };
  },
  computed: {
    ...mapGetters(["token", "notif"]),
  },
  mounted() {
    this.user && this.refresh();
    this.refreshInterval = setInterval(
      function () {
        this.updateClockTime();
      }.bind(this),
      1000
    );
  },
  destroyed() {
    clearInterval(this.refreshInterval);
  },
  methods: {
    updateClockTime() {
      if (this.workingTimeId) {
        const end = moment();
        const duration = moment.duration(end.diff(this.startDateTime));
        const hours = parseInt(duration.asHours());
        const minutes = parseInt(duration.asMinutes()) % 60;
        const seconds = parseInt(duration.asSeconds()) % 60;
        this.workingSince = `${hours}H ${minutes}M ${seconds}S`;
      }
    },
    refresh() {
      axios({
        method: "get",
        url: `${process.env.VUE_APP_API_URL}/api/workingtimes/${this.user.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          const { data } = res.data;
          let len = data.length - 1;
          while (len > 0 && data[len].end) {
            len--;
          }
          if (data.length > 0) {
            this.startDateTime = moment(data[len].start);
            this.clockIn = data[len].status;
            this.workingTimeId = data[len].end ? false : data[len].id;
            this.updateClockTime();
          }
        })
        .catch(err => {
          throw err;
        });
    },
    clock() {
      axios({
        method: "post",
        url: `${process.env.VUE_APP_API_URL}/api/workingtimes/${this.user.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          workingtime: { start: moment().format() },
        },
      })
        .then(() => {
          this.refresh();
        })
        .catch(err => {
          throw err;
        });
    },
    clockOut() {
      axios({
        method: "put",
        url: `${process.env.VUE_APP_API_URL}/api/workingtime/${this.user.id}/${this.workingTimeId}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          workingtime: { end: moment().format() },
        },
      })
        .then(() => {
          this.workingTimeId = null;
          this.refresh;
          this.$store.dispatch("sendNotif", {
            color: "green",
            value: true,
            text: "Good work !",
          });
        })
        .catch(err => {
          throw err;
        });
    },
  },
  watch: {
    user: function () {
      this.refresh();
    },
  },
};
</script>

<style lang="scss">
#ClockManager {
  margin-top: 2rem;
  margin-right: auto;
  margin-left: auto;
  width: 47.5%;
  height: 20rem;
  min-height: 20rem;
  max-height: 20rem;
  .v-card__text {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 73%;
    button {
      margin: auto;
    }
  }

  @media screen and (max-width: 430px) {
    width: 100%;
  }
}
</style>
