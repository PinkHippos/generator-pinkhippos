Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkhipposGenerator extends Generator
  constructor: (args, opts)->
    super args, opts
    message = 'Running generator-pinkhippos'
    @log yosay message
  method_1: =>
    @log chalk.green 'Running method_1 of app'
  intializing: =>
    @log yosay chalk.green 'Running intializing method of app'
    @composeWith require.resolve '../plugin'
