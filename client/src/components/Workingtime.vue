<template>
  <div>
    <v-snackbar
      absolute
      top
      right
      :color="snackbar.color"
      v-model="snackbar.value"
      :timeout="3500"
    >
      {{ snackbar.text }}
      <template v-slot:action="{ attrs }">
        <v-btn
          color="normal"
          text
          v-bind="attrs"
          @click="snackbar.value = false"
        >
          Close
        </v-btn>
      </template>
    </v-snackbar>
    <v-card id="Workingtime" elevation="5">
      <v-card-title>Working Time</v-card-title>
      <v-card-subtitle class="flex">
        <div>You can create workingtimes here !</div>
      </v-card-subtitle>
      <v-card-text v-if="!user"> Please select an user ! </v-card-text>
      <v-card-text v-else>
        <v-form @submit.prevent="createWorkingTime">
          <div class="formMenu">
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
                    label="Start date"
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
                    label="End date"
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
                    label="Start hour"
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
                    label="End hour"
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
            <v-btn type="submit" outlined color="primary">create</v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Workingtime",
  props: ["user"],
  data() {
    return {
      startDate: null,
      startHour: null,
      endDate: null,
      endHour: null,
      menu: false,
      menu2: false,
      menu3: false,
      menu4: false,
      snackbar: { color: "", value: false, text: "" },
    };
  },
  methods: {
    createWorkingTime() {
      if (
        this.startDate != null &&
        this.startHour != null &&
        this.endDate != null &&
        this.endHour != null
      ) {
        axios
          .post(
            `${process.env.VUE_APP_API_URL}/api/workingtimes/${this.user.id}`,
            {
              workingtime: {
                start: this.startDate + " " + this.startHour,
                end: this.endDate + " " + this.endHour,
              },
            }
          )
          .then(res => {
            console.log(res.data);
            this.snackbar = {
              color: "green",
              value: true,
              text: "Working time created !",
            };
          })
          .catch(err => {
            this.snackbar = {
              color: "red",
              value: true,
              text: "Fill the form please !",
            };
            throw err;
          });
      } else {
        this.snackbar = {
          color: "red",
          value: true,
          text: "Fill the form please !",
        };
      }
    },
    updateWorkingTime() {
      console.log("updateWorkingTime");
    },
    deleteWorkingTime() {
      console.log("deleteWorkingTime");
    },
  },
};
</script>

<style lang="scss">
#Workingtime {
  width: max-content;
  margin: 1rem;
  .formMenu {
    display: flex;
    flex-direction: column;
    padding: 1rem;
    button {
      margin: auto;
      margin-right: 0;
      margin-top: 1rem;
    }
  }
}
</style>
