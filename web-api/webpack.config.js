const path = require('path');
const nodeExternals = require('webpack-node-externals');
const CopyPlugin = require('copy-webpack-plugin');
module.exports = {
    mode: 'production',
    entry: './src/main.js',
    externals: [nodeExternals()],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'web-api.js'
    },
    target: 'node',
    plugins: [
        new CopyPlugin({
          patterns: [
            { from: 'src/views', to: './views' },
            { from: 'pm2-prod.json', to: './pm2.json' },
            { from: 'fitsAstrometry', to: './fitsAstrometry' },
            { from: 'package.json', to: './package.json' },
          ],
        }),
      ],
};