<template>
  <div id="teamsTable">
    <v-data-table
      :headers="headers"
      :items="teamsList"
      :single-expand="singleExpand"
      :expanded.sync="expanded"
      item-key="id"
      show-expand
      fixed-header
      class="elevation-5"
    >
      <template v-slot:top>
        <v-toolbar flat color="white">
          <div class="creationBox">
            <v-btn color="success" @click="modalTeam = true">New team</v-btn>
            <UserCreationModal :getTeamsTab="getTeamsTab" />
          </div>
          <v-spacer></v-spacer>
          <v-switch
            v-model="singleExpand"
            label="Single expand"
            class="mt-2"
          ></v-switch>
        </v-toolbar>
      </template>
      <template v-slot:item.actions="{ item }">
        <v-menu
          v-if="item.name != 'No team' && item.manager_id === user.id"
          offset-y
        >
          <template v-slot:activator="{ on, attrs }">
            <v-icon small class="mr-3" v-bind="attrs" v-on="on">
              mdi-account-multiple-plus
            </v-icon>
          </template>
          <v-list v-if="noTeamUsers" class="addUserMenu">
            <v-list-item
              @click="addUser(user.id, item.id)"
              link
              v-for="user in noTeamUsers"
              :key="user.id"
            >
              <v-list-item-title>
                {{ user.username }}
              </v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
        <v-tooltip
          v-if="item.name !== 'No team' && item.manager_id === user.id"
          bottom
        >
          <template v-slot:activator="{ on, attrs }">
            <v-icon
              small
              class="mr-3"
              v-bind="attrs"
              v-on="on"
              @click="(updateTeamModal = true), (teamID = item.id)"
            >
              mdi-pencil
            </v-icon>
          </template>
          <span>Modify team name</span>
        </v-tooltip>
        <v-tooltip
          v-if="item.name !== 'No team' && item.manager_id === user.id"
          bottom
        >
          <template v-slot:activator="{ on, attrs }">
            <v-icon
              small
              v-bind="attrs"
              v-on="on"
              @click="
                (deleteTeamModal = true),
                  (teamID = item.id),
                  (deleteTeamName = item.name)
              "
            >
              mdi-delete
            </v-icon>
          </template>
          <span>Delete team</span>
        </v-tooltip>
      </template>
      <template v-slot:expanded-item="{ headers, item }">
        <td :colspan="headers.length" class="expandedBox">
          <v-simple-table dense class="secondaryTable">
            <thead v-if="checkIfUsersInTeam(item)">
              <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody v-if="checkIfUsersInTeam(item)">
              <tr v-for="team in teamsMembers[item.id] || []" :key="team.id">
                <td>{{ team.id }}</td>
                <td>{{ team.username }}</td>
                <td>{{ team.email }}</td>
                <td>
                  <v-tooltip v-if="item.name !== 'No team'" bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-icon
                        @click="kickUser(team.id)"
                        class="mr-3"
                        small
                        v-bind="attrs"
                        v-on="on"
                      >
                        mdi-account-arrow-down
                      </v-icon>
                    </template>
                    <span>Kick user of the team</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-icon
                        @click="openUserDashboard(team)"
                        class="mr-3"
                        small
                        v-bind="attrs"
                        v-on="on"
                      >
                        mdi-align-vertical-bottom
                      </v-icon>
                    </template>
                    <span>User dashboard</span>
                  </v-tooltip>
                  <v-tooltip v-if="generalManager" bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-icon
                        class="mr-3"
                        @click="promoteUser(team)"
                        small
                        v-bind="attrs"
                        v-on="on"
                      >
                        mdi-arrow-up
                      </v-icon>
                    </template>
                    <span>Promote to manager</span>
                  </v-tooltip>
                  <v-tooltip v-if="generalManager" bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-icon
                        class="mr-3"
                        @click="deleteUser(team)"
                        small
                        v-bind="attrs"
                        v-on="on"
                      >
                        mdi-delete
                      </v-icon>
                    </template>
                    <span>Delete this user</span>
                  </v-tooltip>
                </td>
              </tr>
            </tbody>
            <tbody v-else>
              <tr>
                No users in this team
              </tr>
            </tbody>
          </v-simple-table>
          <TeamChart
            v-if="item.name !== 'No team' && targetDashboardOpen === false"
            v-bind:id_team="item.id"
          />
        </td>
      </template>
    </v-data-table>
    <v-dialog
      v-model="modalTeam"
      transition="dialog-top-transition"
      overlay-opacity="0.75"
      max-width="400"
    >
      <v-card>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Team creation</v-toolbar-title>
        </v-toolbar>
        <v-card-text>
          <v-text-field
            v-model="teamName"
            label="Team name"
            required
            style="margin-top: 1.5rem"
          ></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="addTeam"> Create </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="updateTeamModal"
      transition="dialog-top-transition"
      overlay-opacity="0.75"
      max-width="400"
    >
      <v-card>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Team update</v-toolbar-title>
        </v-toolbar>
        <v-card-text>
          <v-text-field
            v-model="updateTeamName"
            label="Team name"
            required
            style="margin-top: 1.5rem"
          ></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="updateTeam"> Update </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="deleteTeamModal"
      transition="dialog-top-transition"
      overlay-opacity="0.75"
      max-width="400"
    >
      <v-card>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>Delete {{ deleteTeamName }} ?</v-toolbar-title>
        </v-toolbar>
        <v-card-text style="margin-top: 1.5rem">
          Are you sure you want to delete this team?
        </v-card-text>
        <v-card-actions>
          <v-btn color="primary" @click="deleteTeamModal = false">
            Cancel
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn color="error" @click="deleteTeam"> Delete </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="targetDashboardOpen"
      transition="dialog-top-transition"
      overlay-opacity="0.75"
      max-width="87.5%"
    >
      <TargetDashboard :user="targetDashboardUser" />
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import axios from "axios";
import UserCreationModal from "@/components/UserCreationModal.vue";
import TeamChart from "@/components/TeamChart.vue";
import TargetDashboard from "@/components/TargetDashboard.vue";

export default {
  name: "TeamsTable",
  components: { UserCreationModal, TeamChart, TargetDashboard },
  data() {
    return {
      expanded: [],
      teamID: null,
      teamName: null,
      updateTeamName: null,
      deleteTeamName: null,
      singleExpand: true,
      modalTeam: false,
      promoteModal: false,
      updateTeamModal: false,
      deleteTeamModal: false,
      headers: [
        {
          text: "Team ID",
          align: "left",
          sortable: false,
          value: "id",
        },
        { text: "Team name", value: "name", sortable: false },
        { text: "Actions", value: "actions", sortable: false },
      ],
      teamsList: [],
      teamsMembers: {},
      targetDashboardOpen: false,
      targetDashboardUser: null,
    };
  },
  computed: {
    ...mapGetters(["user", "token"]),
    noTeamUsers() {
      const noTeamExist = this.teamsList.filter(
        team => team.name === "No team"
      );
      if (noTeamExist.length <= 0) return null;
      const noTeamID = this.teamsList[this.teamsList.length - 1].id;
      return this.teamsMembers[noTeamID];
    },
    generalManager() {
      if (this.user.role === "GeneralManager") {
        return true;
      } else {
        return false;
      }
    },
  },
  mounted() {
    this.user && this.getTeamsTab();
  },
  methods: {
    getTeamsTab() {
      axios({
        method: "get",
        url: `/api/${this.user.id}/teams`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          const { data } = res.data;
          if (data.length) {
            let temp = [];
            data.forEach(team =>
              temp.push({
                name: team.name,
                id: team.id,
                manager_id: team.manager_id,
              })
            );
            this.teamsList = temp;
          }
          this.getUsers();
        })
        .catch(err => {
          throw err;
        });
    },
    getUsers() {
      axios({
        method: "get",
        url: `/api/users/${this.user.id}/employees`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          const { data } = res.data;
          const noTeamExist = this.teamsList.filter(
            team => team.name === "No team"
          );
          let noTeamId = noTeamExist.length > 0 ? noTeamExist[0].id : null;
          let members = {};
          if (data.length) {
            data.map(team => {
              if (team.role === "GeneralManager") return;
              if (team.team) {
                if (members[team.team]) {
                  members[team.team] = [...members[team.team], team];
                } else {
                  members[team.team] = [team];
                }
              } else {
                if (noTeamId === null) {
                  noTeamId =
                    this.teamsList.length > 0
                      ? this.teamsList[this.teamsList.length - 1].id + 1
                      : 0;
                  this.teamsList.push({
                    name: "No team",
                    id: noTeamId,
                  });
                }
                if (members[noTeamId]) {
                  members[noTeamId] = [...members[noTeamId], team];
                } else {
                  members[noTeamId] = [team];
                }
              }
            });
          }
          this.teamsMembers = members;
        })
        .catch(err => {
          throw err;
        });
    },
    kickUser(userID) {
      axios({
        method: "put",
        url: `${process.env.VUE_APP_API_URL}/api/users/${userID}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          user: {
            team: null,
          },
        },
      }).then(() => {
        this.getTeamsTab();
      });
    },
    addTeam() {
      axios({
        method: "post",
        url: `/api/${this.user.id}/teams`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          team: {
            name: this.teamName,
          },
        },
      })
        .then(res => {
          if (res.status === 201) {
            this.snackbar = {
              color: "green",
              value: true,
              text: "Team created !",
            };
            this.teamName = null;
            this.modalTeam = false;
            this.getTeamsTab();
          } else {
            this.snackbar = {
              color: "red",
              value: true,
              text: "Server error !",
            };
          }
        })
        .catch(err => {
          throw err;
        });
    },
    addUser(userID, teamID) {
      axios({
        method: "put",
        url: `${process.env.VUE_APP_API_URL}/api/users/${userID}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          user: {
            team: teamID,
          },
        },
      })
        .then(() => {
          this.getTeamsTab();
        })
        .catch(err => {
          throw err;
        });
    },
    checkIfUsersInTeam(item) {
      if (this.teamsMembers[item.id]) {
        if (this.teamsMembers[item.id].length > 0) return true;
      } else {
        return false;
      }
    },
    deleteUser(item) {
      axios({
        method: "delete",
        url: `${process.env.VUE_APP_API_URL}/api/users/${item.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          if (res.status === 200) {
            this.$store.dispatch("sendNotif", {
              color: "green",
              value: true,
              text: "User deleted !",
            });
            this.getTeamsTab();
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
    promoteUser(item) {
      this.promoteModal = false;
      axios({
        method: "post",
        url: `${process.env.VUE_APP_API_URL}/api/user/promote/${item.id}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          user: {
            role: "Manager",
          },
        },
      })
        .then(res => {
          if (res.status === 200) {
            this.$store.dispatch("sendNotif", {
              color: "green",
              value: true,
              text: "User promoted !",
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
    updateTeam() {
      axios({
        method: "put",
        url: `${process.env.VUE_APP_API_URL}/api/team/${this.teamID}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
        data: {
          team: {
            name: this.updateTeamName,
          },
        },
      })
        .then(res => {
          if (res.status === 200) {
            this.teamID = null;
            this.updateTeamName = null;
            this.updateTeamModal = false;
            this.$store.dispatch("sendNotif", {
              color: "green",
              value: true,
              text: "Team updated !",
            });
            this.getTeamsTab();
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
    deleteTeam() {
      axios({
        method: "delete",
        url: `${process.env.VUE_APP_API_URL}/api/team/${this.teamID}`,
        headers: {
          Authorization: `Bearer ${this.token}`,
          "Content-Type": "application/json;charset=UTF-8",
        },
      })
        .then(res => {
          if (res.status === 204) {
            this.teamID = null;
            this.deleteTeamModal = false;
            this.deleteTeamName = null;
            this.$store.dispatch("sendNotif", {
              color: "green",
              value: true,
              text: "Team deleted !",
            });
            this.getTeamsTab();
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
    openUserDashboard(user) {
      user.role = this.user.role;
      this.targetDashboardUser = user;
      this.targetDashboardOpen = true;
    },
  },
};
</script>

<style lang="scss">
#teamsTable {
  width: 100%;
  height: 100%;
  background: red;
  .v-data-table {
    height: 100%;
  }
  .creationBox {
    display: flex;
    button {
      margin-right: 1rem;
    }
  }
  .secondaryTable {
    margin: 1.5rem;
  }
  .expandedBox {
    height: 100%;
  }
}
.addUserMenu {
  background: white;
  max-height: 15rem;
}
</style>
