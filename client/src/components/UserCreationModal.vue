<template>
  <div id="employeeCreation">
    <v-btn color="primary" @click="isOpen = true"> New employee </v-btn>
    <v-dialog
      v-model="isOpen"
      transition="dialog-top-transition"
      overlay-opacity="0.75"
      max-width="400"
    >
      <v-card>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Create employee</v-toolbar-title>
        </v-toolbar>
        <v-card-text style="margin-top: 1rem">
          <v-form class="loginForm">
            <v-text-field
              v-model="email"
              prepend-icon="mdi-email"
              label="Email"
              required
            ></v-text-field>
            <v-text-field
              v-model="username"
              prepend-icon="mdi-account"
              label="Username"
              required
            ></v-text-field>
            <v-text-field
              v-model="password"
              prepend-icon="mdi-lock"
              :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
              :type="show ? 'text' : 'password'"
              name="input-10-1"
              label="Password"
              counter
              @click:append="show = !show"
            ></v-text-field>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn :loading="false" color="primary" @click="submitForm">
            Create
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters } from "vuex";

export default {
  name: "UserCreationModal",
  props: {
    getTeamsTab: {
      type: Function,
    },
  },
  data() {
    return {
      isOpen: false,
      show: false,
      email: null,
      password: null,
      username: null,
    };
  },
  computed: {
    ...mapGetters(["user", "token", "notif"]),
  },
  methods: {
    submitForm() {
      if (this.email && this.password && this.username) {
        axios({
          method: "post",
          url: `/api/users/${this.user.id}/employees`,
          headers: {
            Authorization: `Bearer ${this.token}`,
            "Content-Type": "application/json;charset=UTF-8",
          },
          data: {
            user: {
              email: this.email,
              username: this.username,
              password_hash: this.password,
              role: "Employee",
              team: null,
            },
          },
        })
          .then(() => {
            this.isOpen = false;
            this.$store.dispatch("sendNotif", {
              color: "green",
              value: true,
              text: "Employee created !",
            });
            this.getTeamsTab();
          })
          .catch(err => {
            const error = err.response.data.errors;
            if (error["password_hash"] !== undefined) {
              this.$store.dispatch("sendNotif", {
                color: "red",
                value: true,
                text: "Password: " + error.password_hash[0],
              });
            } else if (error["email"] !== undefined) {
              this.$store.dispatch("sendNotif", {
                color: "red",
                value: true,
                text: "Email: " + error.email[0],
              });
            } else if (error["username"] !== undefined) {
              this.$store.dispatch("sendNotif", {
                color: "red",
                value: true,
                text: "Username: " + error.username[0],
              });
            }
            throw err;
          });
      } else {
        console.log("fill all please");
      }
    },
  },
};
</script>

<style lang="scss"></style>
