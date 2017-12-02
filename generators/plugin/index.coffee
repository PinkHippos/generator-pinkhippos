Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkhipposGenerator extends Generator
  constructor: (args, opts)->
    super args, opts
    message = chalk.blue 'Running :plugin'
    @log yosay message
  method_1: =>
    @log chalk.blue 'Running method_1 of plugin'
