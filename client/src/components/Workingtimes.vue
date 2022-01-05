<template>
  <v-card id="Workingtimes" elevation="5">
    <v-fab-transition>
      <v-btn
        @click="getWorkingTimes"
        v-show="user"
        color="primary"
        text
        small
        absolute
        top
        right
      >
        <v-icon small>mdi-refresh</v-icon>
      </v-btn>
    </v-fab-transition>
    <v-dialog width="600" v-model="updateDialog">
      <v-card>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Update a workingtime</v-toolbar-title>
        </v-toolbar>
        <v-card-subtitle class="subtitle">
          You are about to update this working time. <br />
          Start: {{ updateWorkingtime.start }} / End:
          {{ updateWorkingtime.stop }}
        </v-card-subtitle>
        <v-card-text>
          <v-form @submit.prevent="updateWorkingTime">
            <div class="inputsBox">
              <v-row>
                <v-menu
                  ref="menu"
                  v-model="menu"
                  :close-on-content-click="false"
                  :return-value.sync="startDate"
                  transition="scale-transition"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="startDate"
                      label="Date start"
                      prepend-icon="mdi-calendar"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-date-picker v-model="startDate" no-title scrollable>
                    <v-spacer></v-spacer>
                    <v-btn text color="primary" @click="menu = false">
                      Cancel
                    </v-btn>
                    <v-btn
                      text
                      color="primary"
                      @click="$refs.menu.save(startDate)"
                    >
                      OK
                    </v-btn>
                  </v-date-picker>
                </v-menu>
                <v-menu
                  ref="menu2"
                  v-model="menu2"
                  :close-on-content-click="false"
                  :return-value.sync="endDate"
                  transition="scale-transition"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="endDate"
                      label="Date end"
                      prepend-icon="mdi-calendar"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-date-picker v-model="endDate" no-title scrollable>
                    <v-spacer></v-spacer>
                    <v-btn text color="primary" @click="menu2 = false">
                      Cancel
                    </v-btn>
                    <v-btn
                      text
                      color="primary"
                      @click="$refs.menu2.save(endDate)"
                    >
                      OK
                    </v-btn>
                  </v-date-picker>
                </v-menu>
              </v-row>
              <v-row>
                <v-menu
                  ref="menu3"
                  v-model="menu3"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  :return-value.sync="startHour"
                  transition="scale-transition"
                  offset-y
                  max-width="290px"
                  min-width="290px"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="startHour"
                      label="Start Hour"
                      prepend-icon="mdi-clock-time-four-outline"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-time-picker
                    v-if="menu3"
                    v-model="startHour"
                    format="24hr"
                    full-width
                    @click:minute="$refs.menu3.save(startHour)"
                  ></v-time-picker>
                </v-menu>
                <v-menu
                  ref="menu4"
                  v-model="menu4"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  :return-value.sync="endHour"
                  transition="scale-transition"
                  offset-y
                  max-width="290px"
                  min-width="290px"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="endHour"
                      label="End Hour"
                      prepend-icon="mdi-clock-time-four-outline"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-time-picker
                    v-if="menu4"
                    v-model="endHour"
                    format="24hr"
                    full-width
                    @click:minute="$refs.menu4.save(endHour)"
                  ></v-time-picker>
                </v-menu>
              </v-row>
            </div>
            <div class="modalButtons">
              <v-btn type="submit" outlined color="primary">Update</v-btn>
              <v-btn outlined @click="updateDialog = false"> Cancel </v-btn>
            </div>
          </v-form>
        </v-card-text>
      </v-card>
    </v-dialog>
    <v-card-title>Your workingtimes list</v-card-title>
    <v-card-text v-if="user">
      <v-simple-table fixed-header height="15rem">
        <template v-slot:default>
          <thead>
            <tr>
              <th class="text-left">Start</th>
              <th class="text-left">End</th>
              <th v-if="manager" class="text-left"></th>
              <th v-if="manager" class="text-left"></th>
            </tr>
          </thead>
          <tbody v-if="data" class="body">
            <tr v-for="item in data" :key="item.id">
              <td>{{ item.start }}</td>
              <td>{{ item.end }}</td>
              <td v-if="manager">
                <v-btn
                  outlined
                  small
                  color="primary"
                  @click="updateDialogModal(item)"
                >
                  <v-icon small>mdi-update</v-icon>
                </v-btn>
              </td>
              <td v-if="manager">
                <v-btn
                  outlined
                  small
                  color="error"
                  @click="deleteWorkingTime(item)"
                >
                  <v-icon small>mdi-delete</v-icon>
                </v-btn>
              </td>
            </tr>
          </tbody>
          <tbody v-else class="body">
            <tr>
              <td>No data</td>
              <td>No data</td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-card-text>
    <v-card-text v-else> Please select an user ! </v-card-text>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import axios from "axios";

export default {
  name: "Workingtimes",
  props: {
    user: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      data: null,
      startDate: null,
      startHour: null,
      endDate: null,
      endHour: null,
      menu: false,
      menu2: false,
      menu3: false,
      menu4: false,
      updateDialog: false,
      updateWorkingtime: [{ start: null }, { end: null }, { id: null }],
    };
  },
  computed: {
    ...mapGetters(["token", "notif"]),
    manager() {
      if (this.user.role === "Manager" || this.user.role === "GeneralManager") {
        return true;
      } else {
        return false;
      }
    },
  },
  mounted() {
    this.user && this.getWorkingTimes();
  },
  methods: {
    updateDialogModal(item) {
      this.updateDialog = true;
      this.updateWorkingtime.start = item.start;
      this.updateWorkingtime.stop = item.end;
      this.updateWorkingtime.id = item.id;
    },
    updateWorkingTime() {
      if (
        this.startDate != null &&
        this.startHour != null &&
        this.endDate != null &&
        this.endHour != null
      ) {
        axios({
          method: "put",
          url: `${process.env.VUE_APP_API_URL}/api/workingtime/${this.user.id}/${this.updateWorkingtime.id}`,
          headers: {
            Authorization: `Bearer ${this.token}`,
            "Content-Type": "application/json;charset=UTF-8",
          },
          data: {
            workingtime: {
              start: this.startDate + " " + this.startHour,
              end: this.endDate + " " + this.endHour,
            },
          },
        })
          .then(() => {
            this.updateDialog = false;
            this.getWorkingTimes();
            this.$store.dispatch("sendNotif", {
              color: "green",
              value: true,
              text: "Workingtime updated !",
            });
          })
          .catch(err => {
            this.$store.dispatch("sendNotif", {
              color: "red",
              value: true,
              text: "Error occured !",
            });
            throw err;
          });
      } else {
        this.$store.dispatch("sendNotif", {
          color: "red",
          value: true,
          text: "Fill al the fields !",
        });
      }
    },
    deleteWorkingTime(item) {
      axios({
        method: "delete",
        url: `${process.env.VUE_APP_API_URL}/api/workingtime/${this.user.id}/${item.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          if (res.status === 204) {
            this.getWorkingTimes();
            this.$store.dispatch("sendNotif", {
              color: "green",
              value: true,
              text: "Workingtime deleted !",
            });
          } else {
            this.$store.dispatch("sendNotif", {
              color: "red",
              value: true,
              text: "Error occured !",
            });
          }
        })
        .catch(err => {
          this.$store.dispatch("sendNotif", {
            color: "red",
            value: true,
            text: "Error occured !",
          });
          throw err;
        });
    },
    getWorkingTimes() {
      axios({
        method: "get",
        url: `${process.env.VUE_APP_API_URL}/api/workingtimes/${this.user.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          let localData = res.data.data;
          if (localData.length > 0) this.data = localData;
          else this.data = null;
        })
        .catch(err => {
          throw err;
        });
    },
  },
  watch: {
    user: function () {
      this.user && this.getWorkingTimes();
    },
    notif: function () {
      if (
        this.notif.text === "Good work !" ||
        this.notif.text === "Workingtime deleted !" ||
        this.notif.text === "Workingtime updated !"
      )
        this.getWorkingTimes();
    },
  },
};
</script>

<style lang="scss">
#Workingtimes {
  width: 100%;
}

.modalButtons {
  button {
    margin-right: 1rem;
    margin-top: 1rem;
  }
}
.inputsBox {
  margin: 1rem;
}

.subtitle {
  margin-top: 1rem;
}
</style>
