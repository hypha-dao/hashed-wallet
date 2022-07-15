var path = require('path');

module.exports = {
    entry: './src/index.js',
    mode: 'development',
    output: {
      path: path.resolve(__dirname, '../assets/polkadot'),
      filename: 'polkajs.bundle.js',
      globalObject: 'this',
      library: "polka",
      libraryTarget: 'var'
    },    
};
  