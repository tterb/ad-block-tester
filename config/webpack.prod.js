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
	devServer: {
		static: {
			directory: config.dist,
			publicPath: '/'
		},
		compress: true,
		port: 5556,
		hot: true,
		open: '/',
		historyApiFallback: true
	},
	plugins: [new CleanWebpackPlugin()]
})
