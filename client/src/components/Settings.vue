<template>
  <div id="settings">
    <h1>Account informations</h1>
    <h2>You can change your account informations</h2>
    <v-divider />
    <div class="line">
      <div>
        <p class="lineTitle">Username</p>
        <p class="lineSubtitle">Enter your username</p>
      </div>
      <v-spacer />
      <div>
        <v-text-field
          class="input"
          v-model="username"
          prepend-inner-icon="mdi-account"
          background-color="rgb(250, 245, 245)"
          rounded
          solo
        ></v-text-field>
      </div>
    </div>
    <v-divider />
    <div class="line">
      <div>
        <p class="lineTitle">Email adress</p>
        <p class="lineSubtitle">Enter your email address</p>
      </div>
      <v-spacer />
      <div>
        <v-text-field
          class="input"
          v-model="email"
          prepend-inner-icon="mdi-email"
          background-color="rgb(250, 245, 245)"
          rounded
          solo
        ></v-text-field>
      </div>
    </div>
    <v-divider />
    <div class="line">
      <div>
        <p class="lineTitle">Password</p>
        <p class="lineSubtitle">You can change your password</p>
      </div>
      <v-spacer />
      <div>
        <v-text-field
          class="input"
          v-model="password"
          background-color="rgb(250, 245, 245)"
          prepend-inner-icon="mdi-lock"
          :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
          :type="show ? 'text' : 'password'"
          @click:append="show = !show"
          rounded
          solo
        ></v-text-field>
      </div>
    </div>
    <v-divider />
    <div class="saveDiv">
      <v-btn color="error" @click="dialog = true">Delete account</v-btn>
      <v-btn color="primary" :loading="loading" @click="save">Save</v-btn>
    </div>
    <v-dialog
      v-model="dialog"
      transition="dialog-top-transition"
      max-width="300"
    >
      <v-card>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Delete this account ?</v-toolbar-title>
        </v-toolbar>
        <v-card-actions class="actionsButtons">
          <v-spacer />
          <v-btn color="error" @click="deleteAccount">Yes !</v-btn>
          <v-btn @click="dialog = false"> Cancel </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "Settings",
  data() {
    return {
      username: null,
      email: null,
      password: null,
      show: false,
      loading: false,
      dialog: false,
    };
  },
  computed: {
    ...mapGetters(["user", "notif"]),
  },
  mounted() {
    this.username = this.user.username;
    this.email = this.user.email;
  },
  methods: {
    save() {
      if (this.username && this.email && this.password) {
        this.loading = true;
        this.$store
          .dispatch("updateUser", {
            username: this.username,
            email: this.email,
            password: this.password,
          })
          .then(
            () => {
              setTimeout(() => {
                this.loading = false;
                this.$store.dispatch("sendNotif", {
                  color: "green",
                  value: true,
                  text: "Account updated !",
                });
              }, 1000);
            },
            err => {
              const error = err.response.data.errors;
              if (error["password_hash"] !== undefined) {
                this.$store.dispatch("sendNotif", {
                  color: "red",
                  value: true,
                  text: "Password: " + error.password_hash[0],
                }),
                  (this.loading = false);
              } else if (error["email"] !== undefined) {
                this.$store.dispatch("sendNotif", {
                  color: "red",
                  value: true,
                  text: "Email: " + error.email[0],
                }),
                  (this.loading = false);
              } else if (error["username"] !== undefined) {
                this.$store.dispatch("sendNotif", {
                  color: "red",
                  value: true,
                  text: "Username: " + error.username[0],
                }),
                  (this.loading = false);
              }
            }
          );
      } else {
        this.$store.dispatch("sendNotif", {
          color: "red",
          value: true,
          text: "Please fill all fields !",
        });
      }
    },
    deleteAccount() {
      this.$store.dispatch("deleteUser").then(
        () => {
          this.dialog = false;
          this.$router.push("/");
        },
        err => {
          console.log(err.response.data.error);
          this.dialog = false;
          this.$store.dispatch("sendNotif", {
            color: "red",
            value: true,
            text: err.response.data.error,
          });
        }
      );
    },
  },
};
</script>

<style lang="scss" scoped>
#settings {
  width: 100%;
  margin-top: auto;
  margin-bottom: auto;
  h2 {
    margin-bottom: 2rem;
  }
  .line {
    margin-top: 1.5rem;
    margin-bottom: 1.5rem;
    display: flex;
    .lineTitle {
      margin-bottom: 0.25rem;
      font-size: 1.6rem;
      font-weight: 700;
    }
    .lineSubtitle {
      font-size: 0.75rem;
      font-weight: 400;
      color: rgb(160, 145, 145);
    }
    .input {
      width: 20rem;
    }
  }
  .saveDiv {
    display: flex;
    margin-top: 1.5rem;
    button:first-child {
      margin: auto;
      margin-left: 0;
    }
    button:last-child {
      margin: auto;
      margin-right: 0;
    }
  }

  @media screen and (max-width: 430px) {
    .line {
      flex-direction: column;
    }
  }
}

.actionsButtons {
  margin-top: 1rem;
}
</style>
