<template>
  <div>
    <v-dialog
      v-model="dialog"
      transition="dialog-top-transition"
      overlay-opacity="0.85"
      max-width="400"
      persistent
    >
      <v-card>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Sign In</v-toolbar-title>
        </v-toolbar>
        <v-card-text>
          <v-form class="loginForm">
            <v-text-field
              v-model="email"
              prepend-icon="mdi-account"
              label="Email"
              required
            ></v-text-field>
            <v-text-field
              v-model="password"
              prepend-icon="mdi-lock"
              :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
              :type="show ? 'text' : 'password'"
              label="Password"
              counter
              @click:append="show = !show"
            ></v-text-field>
            <v-checkbox v-model="checkbox" label="Stay logged in"></v-checkbox>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="submitForm"> Login </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "Signin",
  data() {
    return {
      dialog: false,
      show: false,
      email: null,
      password: null,
      checkbox: false,
    };
  },
  computed: {
    ...mapGetters(["user", "notif"]),
  },
  mounted() {
    this.user ? (this.dialog = false) : (this.dialog = true);
  },
  watch: {
    user: function () {
      this.user ? (this.dialog = false) : (this.dialog = true);
    },
  },
  methods: {
    submitForm() {
      this.$store
        .dispatch("login", {
          email: this.email,
          password: this.password,
          remember_me: this.checkbox,
        })
        .then(
          () => {
            this.dialog = false;
            this.$router.push("/dashboard");
          },
          err => {
            console.log(err);
            this.$store.dispatch("sendNotif", {
              color: "red",
              value: true,
              text: "User not found !",
            });
          }
        );
    },
  },
};
</script>

<style lang="scss" scoped>
.loginForm {
  padding-top: 2rem;
  padding-bottom: 0rem;
  padding-right: 0.5rem;
  padding-left: 0.5rem;
}
</style>
