import Vue from "vue";
import VueRouter from "vue-router";
import AppBase from "@/components/AppBase.vue";
import store from "@/store";

Vue.use(VueRouter);

const ifAuthenticated = (to, from, next) => {
  if (store.getters["user"]) {
    next("/dashboard");
  } else {
    next();
  }
};

const ifNotAuthenticated = (to, from, next) => {
  if (!store.getters["user"]) {
    next("/");
  } else {
    next();
  }
};

const ifManagerOrGeneral = (to, from, next) => {
  const user = store.getters["user"];
  if (user && (user.role === "Manager" || user.role === "GeneralManager")) {
    next();
  } else {
    next("/dashboard");
  }
};

const routes = [
  {
    path: "/",
    component: AppBase,
    children: [
      {
        path: "/",
        name: "signin",
        beforeEnter: ifAuthenticated,
      },
      {
        path: "/teams",
        name: "teams",
        beforeEnter: ifManagerOrGeneral,
        component: () =>
          import(/* webpackChunkName: "Teams" */ "@/components/Teams.vue"),
      },
      {
        path: "/dashboard",
        name: "dashboard",
        beforeEnter: ifNotAuthenticated,
        component: () =>
          import(
            /* webpackChunkName: "Dashboard" */ "@/components/Dashboard.vue"
          ),
      },
      {
        path: "/settings",
        name: "settings",
        beforeEnter: ifNotAuthenticated,
        component: () =>
          import(
            /* webpackChunkName: "Settings" */ "@/components/Settings.vue"
          ),
      },
    ],
  },
  {
    path: "*",
    redirect: "/",
  },
];

const router = new VueRouter({
  mode: "history",
  routes,
});

export default router;
