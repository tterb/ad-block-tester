const main = require('./webpack.main')
const config = require('./config')
const { merge } = require('webpack-merge')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const TerserPlugin = require('terser-webpack-plugin')

module.exports = merge(main, {
	mode: 'production',
	optimization: {
		minimize: true,
		minimizer: [
			new TerserPlugin({
				test: /\.js(\?.*)?$/i
			})
		]
	},
	output: {
	  publicPath: '/ad-block-test',
	},
	devServer: {
		static: {
			directory: config.dist,
			publicPath: '/ad-block-test'
		},
		compress: true,
		allowedHosts: ['all'],
		port: 5556,
		hot: true,
		open: '/',
		historyApiFallback: true
	},
	plugins: [new CleanWebpackPlugin()]
})
