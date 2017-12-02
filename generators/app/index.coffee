Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkhipposGenerator extends Generator
  constructor: (args, opts)->
    super args, opts
    message = "Running: #{chalk.green 'generator-pinkhippos'}"
    @argument 'create_plugins', {
      desc: 'Boolean to determin if :plugin sub_generator will be run'
      type: Boolean
      required: false
      default: true
    }
    @argument 'create_cmds', {
      desc: 'Boolean to determine if :seneca_action will be run for each plugin'
      type: Boolean
      required: false
      default: true
    }
    @generators_to_run = {}
    @log yosay message
  prompting: =>
    plugin_prompts = [
      {
        type: 'confirm'
        name: 'create_plugins'
        message: 'Would you like to create plugins now?'
        default: @options.create_plugins
      }
    ]
    @prompt plugin_prompts
      .then (plugin_answers)=>
        if plugin_answers.create_plugins
          @prompt [{
            type: 'confirm'
            name: 'create_cmds'
            message: 'Would you like to create actions for the plugins now?'
            default: @options.create_cmds
          }]
          .then (cmd_answers)=>
            @options.create_cmds = cmd_answers.create_cmds
  intializing: =>
    @log "Running #{chalk.green 'intializing method'} of app"
    if @options.create_plugins
      @composeWith require.resolve '../plugin'
  end: =>
    @log yosay chalk.green "Fin!"
