Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposSenecaActionGenerator extends Generator

  constructor: (args, opts)->
    super args, opts
    # @log "Constructing :seneca_action generator"
    @argument 'role', {
      type: String
      description: 'The name of the plugin to add actions to.'
      default: 'ph_dummy_plugin'
    }
    @argument 'command', {
      type: String
      description: 'The value for the cmd of the action.'
      default: 'dummy_cmd'
    }
  prompting: =>
    # @prompt [
    #   {
    #     type: 'confirm'
    #     name: 'create-tests'
    #     message: 'Would you like to generate a test for the action?'
    #     default: true
    #   }
    # ]
    # .then (answers)=>
    #   @_update_opts answers

  configuring: =>
    # current_plugins = @config.get('plugins') ? {}
    # current_config = current_plugins[@options.plugin_name] ? {}
    # actions = current_config.actions ? []
    # if actions.indexOf(@options.command) != -1
    #   @options.command = @_next_numbered_name @options.command, actions
    # plugins = {}
    # plugins[@options.plugin_name] = Object.assign {}, current_config, {
    #   actions: actions.concat @options.command
    #   'create-tests': @options['create-tests']
    # }
    # updated_plugins = Object.assign {}, @config.get('plugins'), plugins
    # @config.set 'plugins', updated_plugins


  intializing: =>

  writing: =>
    @fs.copyTpl(
      @templatePath 'action_file.coffee'
      @destinationPath "src/plugins/#{@options.role}/#{@options.command}.coffee"
      {command: @options.command}
    )

  conflicts: =>

  install: =>

  end: =>
