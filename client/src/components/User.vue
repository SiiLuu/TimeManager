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
    <v-dialog width="300" v-model="dialog">
      <v-card>
        <v-card-title> Delete a user </v-card-title>
        <v-card-subtitle> You are about to remove this user. </v-card-subtitle>
        <v-card-text>
          <div class="removeButtons">
            <v-btn color="error" @click="deleteUser"> Yes, do it ! </v-btn>
            <v-btn color="normal" @click="dialog = false"> Cancel </v-btn>
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>
    <v-card id="User" elevation="5">
      <v-fab-transition>
        <v-btn
          @click="backHome"
          v-show="user"
          color="primary"
          text
          small
          absolute
          top
          right
        >
          <v-icon small>mdi-arrow-left</v-icon>Disconnect
        </v-btn>
      </v-fab-transition>
      <div v-if="!user">
        <v-card-title>Select a user</v-card-title>
        <v-card-subtitle> Enter email and username ! </v-card-subtitle>
      </div>
      <div v-else>
        <v-card-title>User id {{ user.id }}</v-card-title>
        <v-card-subtitle> This is your current user ! </v-card-subtitle>
      </div>
      <v-card-text>
        <v-form>
          <v-col>
            <v-text-field
              v-model="email"
              label="Email"
              :disabled="!user || editing ? false : true"
              required
            ></v-text-field>
          </v-col>
          <v-col>
            <v-text-field
              v-model="username"
              label="Username"
              :disabled="!user || editing ? false : true"
              required
            ></v-text-field>
          </v-col>
          <div class="selectButton" v-if="!user">
            <v-btn outlined color="primary" @click="getUser">Select</v-btn>
            <v-btn outlined @click="createUser">Create</v-btn>
          </div>
          <div v-else-if="user && editing" class="userButtons">
            <v-btn outlined color="success" @click="updateUser">Update</v-btn>
            <v-btn outlined @click="editing = false"> Cancel </v-btn>
          </div>
          <div v-else class="userButtons">
            <v-btn outlined @click="editing = true">Update</v-btn>
            <v-btn outlined color="error" @click="dialog = true">Delete</v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "User",
  props: ["user"],
  data() {
    return {
      email: null,
      username: null,
      snackbar: { color: "", value: false, text: "" },
      dialog: false,
      editing: false,
    };
  },
  mounted() {
    if (this.user) {
      this.email = this.user.email;
      this.username = this.user.username;
    }
  },
  methods: {
    getUser() {
      axios
        .get(
          `${process.env.VUE_APP_API_URL}/api/users?email=${this.email}&username=${this.username}`
        )
        .then(res => {
          if (res.data.data.length > 0) {
            this.$emit("UserChanged", res.data.data[0]);
            localStorage.setItem("user", JSON.stringify(res.data.data[0]));
          } else {
            this.snackbar = {
              color: "red",
              value: true,
              text: "User not found !",
            };
          }
        })
        .catch(err => {
          throw err;
        });
    },
    createUser() {
      axios
        .post(process.env.VUE_APP_API_URL + "/api/users", {
          user: { email: this.email, username: this.username, role: "Manager" },
        })
        .then(res => {
          if (res.status === 201) {
            this.snackbar = {
              color: "green",
              value: true,
              text: "User created !",
            };
            this.email = null;
            this.username = null;
          } else {
            this.snackbar = {
              color: "red",
              value: true,
              text: "Server error !",
            };
          }
        })
        .catch(err => {
          this.snackbar = { color: "red", value: true, text: "Server error !" };
          throw err;
        });
    },
    updateUser() {
      axios
        .put(`${process.env.VUE_APP_API_URL}/api/users/${this.user.id}`, {
          user: { email: this.email, username: this.username },
        })
        .then(res => {
          if (res.status === 200) {
            this.editing = false;
            this.snackbar = {
              color: "green",
              value: true,
              text: "User updated !",
            };
            // this.user = res.data.data;
            this.$emit("UserChanged", this.user);
            localStorage.removeItem("user");
            localStorage.setItem("user", JSON.stringify(res.data.data));
          } else {
            this.snackbar = {
              color: "red",
              value: true,
              text: "Server error !",
            };
          }
        })
        .catch(err => {
          this.snackbar = { color: "red", value: true, text: "Server error !" };
          throw err;
        });
    },
    deleteUser() {
      axios
        .delete(`${process.env.VUE_APP_API_URL}/api/users/${this.user.id}`)
        .then(res => {
          if (res.status === 204) {
            this.snackbar = {
              color: "green",
              value: true,
              text: "User deleted !",
            };
            this.dialog = false;
            // this.user = null;
            this.email = null;
            this.username = null;
            this.$emit("UserChanged", null);
            localStorage.removeItem("user");
          } else {
            this.snackbar = {
              color: "red",
              value: true,
              text: "Server error !",
            };
          }
        })
        .catch(err => {
          this.snackbar = { color: "red", value: true, text: "Server error !" };
          throw err;
        });
    },
    backHome() {
      localStorage.removeItem("user");
      this.email = null;
      this.username = null;
      this.$emit("UserChanged", null);
    },
  },
};
</script>

<style lang="scss">
#User {
  width: max-content;
  margin: 1rem;
}

.selectButton,
.userButtons,
.removeButtons {
  display: flex;
  button {
    margin: auto;
  }
}
</style>
