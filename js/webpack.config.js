// var path = require('path');
// const webpack = require("webpack");

// module.exports = {
//     entry: './src/index.js',
//     mode: 'development',
//     output: {
//       path: path.resolve(__dirname, '../assets/polkadot'),
//       filename: 'polkajs.bundle.js',
//       globalObject: 'this',
//       library: "polka",
//       libraryTarget: 'var'
//     },    
// };
  
// module.exports = {
//   entry: path.resolve(__dirname, 'src/index.js'),  
//   output: {
//     path: path.resolve(__dirname, '../assets/polkadot'),
//     filename: 'polkajs.bundle.js',
//     globalObject: 'this',
//     library: 'polka',
//     libraryTarget: 'umd',
//   },
  
//   resolve: {
//     extensions: [".ts", ".js", ".mjs", ".cjs", ".json"],
//     fallback: { crypto: require.resolve("crypto-browserify"), stream: require.resolve("stream-browserify") },
//   },
    
// module: {
  
//     rules: [
//       {
//         test: /\.ts$/,
//         use: "babel-loader",
//         exclude: /node_modules/,
//       },
//       {
//         test: /\.js$/,
//         exclude: /node_modules/,
//         use: "babel-loader",
//       },
//       {
//         test: /\.mjs$/,
//         include: /node_modules/,
//         type: "javascript/auto",
//       },
//       {
//         test: /\.cjs$/,
//         include: path.resolve(__dirname, "node_modules/@polkadot/"),
//         use: "babel-loader",
//       },
//       {
//         test: /\.js$/,
//         include: path.resolve(__dirname, "node_modules/@polkadot/"),
//         use: "babel-loader",
//       },
//     ],
//   }
// };

const path = require("path");
const webpack = require("webpack");

const config = {
  entry: "./src/index.js",
  mode: 'development',
  output: {
    publicPath: path.resolve(__dirname, ""),
    path: path.resolve(__dirname, '../assets/polkadot'),
    filename: 'polkajs.bundle.js',
},
  resolve: {
    extensions: [".ts", ".js", ".mjs", ".cjs", ".json"],
    fallback: { crypto: require.resolve("crypto-browserify"), stream: require.resolve("stream-browserify") },
  },
  plugins: [
    new webpack.ProvidePlugin({
      process: "process/browser.js",
    }),
  ],
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: "babel-loader",
        exclude: /node_modules/,
      },
      {
        test: /\.mjs$/,
        include: /node_modules/,
        type: "javascript/auto",
      },
      {
        test: /\.cjs$/,
        include: path.resolve(__dirname, "node_modules/@polkadot/"),
        use: "babel-loader",
      },
      {
        test: /\.js$/,
        include: path.resolve(__dirname, "node_modules/@polkadot/"),
        use: "babel-loader",
      },
    ],
  },
};

module.exports = config;
