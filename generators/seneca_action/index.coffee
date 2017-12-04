PinkHipposGenerator = require '../app'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposSenecaActionGenerator extends PinkHipposGenerator

  constructor: (args, opts)->
    super args, opts
    # @log "Constructing :seneca_action generator"
    @argument 'plugin_name', {
      type: String
      description: 'The name of the plugin to add actions to.'
      default: @options.plugin_name ? @options.role
    }
    @argument 'command', {
      type: String
      description: 'The value for the cmd of the action.'
      default: @options.command ? 'dummy_cmd'
    }
  prompting: =>
    @log "Prompting :seneca_action"

  configuring: =>
    @log "Configuring :seneca_action for #{@options.plugin_name}"
    current_plugins = @config.get('plugins') ? {}
    current_config = current_plugins[@options.plugin_name] ? {}
    actions = current_config.actions ? []
    if actions.indexOf(@options.command) != -1
      @options.command = @_next_numbered_name @options.command, actions
    plugins = {}
    plugins[@options.plugin_name] = Object.assign {}, current_config, {
      actions: actions.concat @options.command
    }
    updated_plugins = Object.assign {}, @config.get('plugins'), plugins
    @config.set 'plugins', updated_plugins


  intializing: =>
    @log "Intializing :seneca_action"

  build_action: =>
    pattern = "role:#{@options.plugin_name}, cmd:#{@options.command}"
    @log "Building #{pattern} in :seneca_action"

  writing: =>
    @config.get('plugins')[@options.plugin_name].actions.forEach (command)=>
      @fs.copyTpl(
        @templatePath 'action_file.coffee'
        @destinationPath "src/plugins/#{@options.plugin_name}/#{command}.coffee"
        {command}
      )

  conflicts: =>
    @log "Handling conflicts for :seneca_action"

  install: =>
    @log "Running install for :seneca_action"

  end: =>
    @log "All done in :seneca_action"
