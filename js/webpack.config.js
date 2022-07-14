var path = require('path');
module.exports = {
    entry: './src/index.js',
    output: {
      path: path.resolve(__dirname, '../assets/polkadot'),
      filename: 'polkajs.bundle.js',
    },    
};
  