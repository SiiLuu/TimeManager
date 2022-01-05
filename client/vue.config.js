const webpack = require("webpack");
module.exports = {
  devServer: {
    proxy: {
      "^/api/": {
        target: process.env.VUE_APP_API_PROXY,
        pathRewrite: { "^/api/": "/api/" },
        changeOrigin: true,
        logLevel: "debug",
      },
    },
  },
  configureWebpack: {
    plugins: [new webpack.ProvidePlugin({ jQuery: "jquery" })],
  },
  transpileDependencies: ["vuetify"],
  outputDir: "../mobile/www",
  publicPath: "./",
};
