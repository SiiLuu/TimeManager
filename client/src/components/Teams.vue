<template>
  <div id="teams">
    <TeamsTable />
  </div>
</template>

<script>
import Raphael from "raphael/raphael";
import TeamsTable from "@/components/TeamsTable.vue";
global.Raphael = Raphael;

export default {
  name: "Teams",
  components: { TeamsTable },
};
</script>

<style lang="scss">
#teams {
  width: 100%;
  height: 100%;
  margin-top: auto;
  margin-bottom: auto;
}
</style>
