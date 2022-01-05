import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.use(Vuex);

const SET_USER = "SET_USER";
const SET_TOKEN = "SET_TOKEN";
const SET_NOTIF = "SET_NOTIF";

export default new Vuex.Store({
  state: {
    token: localStorage.getItem("time_manager_token") || null,
    user: JSON.parse(localStorage.getItem("time_manager_user")) || null,
    notif: { color: "", value: false, text: "" },
  },
  getters: {
    token: state => state.token,
    user: state => state.user,
    notif: state => state.notif,
  },
  mutations: {
    [SET_TOKEN](state, value) {
      state.token = value;
    },
    [SET_USER](state, value) {
      state.user = value;
    },
    [SET_NOTIF](state, value) {
      state.notif = value;
    },
  },
  actions: {
    login({ commit }, credentials) {
      return axios
        .post(process.env.VUE_APP_API_URL + "/api/users/sign_in", {
          user: {
            email: credentials.email,
            password: credentials.password,
          },
        })
        .then(res => {
          if (res.status === 200) {
            commit(SET_USER, res.data.user);
            commit(SET_TOKEN, res.data.jwt);
            if (credentials.remember_me) {
              localStorage.setItem(
                "time_manager_user",
                JSON.stringify(res.data.user)
              );
              localStorage.setItem("time_manager_token", res.data.jwt);
            }
          } else {
            throw "Error";
          }
        })
        .catch(err => {
          throw err;
        });
    },
    logout({ commit }) {
      commit(SET_USER, null);
      commit(SET_TOKEN, null);
      localStorage.removeItem("time_manager_user");
      localStorage.removeItem("time_manager_token");
    },
    sendNotif({ commit }, notif) {
      commit(SET_NOTIF, notif);
    },
    updateUser({ commit, state }, credentials) {
      return axios({
        method: "put",
        url: `${process.env.VUE_APP_API_URL}/api/users/${state.user.id}`,
        headers: {
          Authorization: `Bearer ${state.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          user: {
            email: credentials.email,
            username: credentials.username,
            password_hash: credentials.password,
          },
        },
      })
        .then(res => {
          commit(SET_USER, res.data.data);
          localStorage.setItem(
            "time_manager_user",
            JSON.stringify(res.data.data)
          );
        })
        .catch(err => {
          throw err;
        });
    },
    deleteUser({ dispatch, state }) {
      return axios({
        method: "delete",
        url: `${process.env.VUE_APP_API_URL}/api/users/${state.user.id}`,
        headers: {
          Authorization: `Bearer ${state.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          console.log(res.data);
          dispatch("logout");
        })
        .catch(err => {
          throw err;
        });
    },
  },
});
