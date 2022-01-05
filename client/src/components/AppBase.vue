<template>
  <div id="appBase">
    <v-snackbar
      class="notif"
      fixed
      bottom
      right
      :color="notif.color"
      v-model="notif.value"
      :timeout="3500"
    >
      {{ notif.text }}
      <template v-slot:action="{ attrs }">
        <v-btn color="normal" text v-bind="attrs" @click="notif.value = false">
          Close
        </v-btn>
      </template>
    </v-snackbar>

    <Signin />

    <v-app-bar class="appBar" app color="primary" elevation="6" dark>
      <div class="d-flex align-center">
        <v-img
          alt="Vuetify Logo"
          class="shrink mr-4"
          contain
          src="https://cdn.vuetifyjs.com/images/logos/vuetify-logo-dark.png"
          transition="scale-transition"
          width="35"
        />
      </div>
      <v-toolbar-title class="appTitle">Time Manager</v-toolbar-title>
      <v-spacer></v-spacer>
      <div v-if="user">
        <v-icon class="mr-2" dark> mdi-account-circle </v-icon>
        <span class="mr-4">{{ user.username }}</span>
      </div>
      <v-menu bottom left offset-y>
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item @click="logout">
            <v-list-item-title>
              <v-icon class="mr-1"> mdi-logout </v-icon>
              Logout
            </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <template v-slot:extension>
        <v-tabs
          :align-with-title="desktop ? true : false"
          :center-active="!desktop ? true : false"
          v-model="currentTab"
        >
          <v-tab v-for="tab in tabs" :key="tab" @click="changeTab(tab)">
            {{ tab }}
          </v-tab>
        </v-tabs>
      </template>
    </v-app-bar>

    <v-main>
      <div class="mainView">
        <div class="mainBox">
          <router-view />
        </div>
      </div>
    </v-main>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import Signin from "@/components/Signin.vue";

export default {
  name: "AppBase",
  components: {
    Signin,
  },
  data() {
    return {
      tabs: null,
      currentTab: null,
    };
  },
  computed: {
    ...mapGetters(["user", "notif"]),
    desktop() {
      return this.$vuetify.breakpoint.sm;
    },
  },
  mounted() {
    this.setTabs();
  },
  watch: {
    user: function () {
      this.setTabs();
    },
  },
  methods: {
    setTabs() {
      if (this.user) {
        if (
          this.user.role === "Manager" ||
          this.user.role === "GeneralManager"
        ) {
          this.tabs = ["Dashboard", "Teams", "Settings"];
        } else {
          this.tabs = ["Dashboard", "Settings"];
        }
        const currentRoute =
          this.$route.name.charAt(0).toUpperCase() + this.$route.name.slice(1);
        const index = this.tabs.indexOf(currentRoute);
        this.currentTab = index;
      }
    },
    changeTab(tab) {
      this.$router.push(`/${tab.toLowerCase()}`);
    },
    logout() {
      this.currentTab = null;
      this.$store.dispatch("logout");
      this.$router.push("/");
    },
  },
};
</script>

<style lang="scss">
#appBase {
  width: 100%;
  height: 100%;
  h1 {
    font-size: 2rem;
    font-weight: 900;
  }
  h2 {
    font-size: 1rem;
    font-weight: 400;
    color: rgb(160, 145, 145);
  }
  .notif {
    z-index: 9999;
  }
  .appBar {
    padding: 0 7.5%;
  }
  .v-main {
    width: 100%;
    height: 100%;
    .mainView {
      width: 100%;
      height: 100%;
      padding: 2.5% 7.5%;
      color: rgb(45, 45, 45);
      .mainBox {
        display: flex;
        width: 100%;
        height: 100%;
      }
    }
  }

  @media screen and (max-width: 430px) {
    .appTitle {
      display: none;
    }
  }
}
</style>
