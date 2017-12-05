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
    @option 'create-tests', {
      type: Boolean
      description: 'Determines if a test file will be generated for the action.'
    }
  prompting: =>
    @prompt [
      {
        type: 'confirm'
        name: 'create-tests'
        message: 'Would you like to generate a test for the action?'
        default: true
      }
    ]
    .then (answers)=>
      @_update_opts answers

  configuring: =>
    current_plugins = @config.get('plugins') ? {}
    current_config = current_plugins[@options.plugin_name] ? {}
    actions = current_config.actions ? []
    if actions.indexOf(@options.command) != -1
      @options.command = @_next_numbered_name @options.command, actions
    plugins = {}
    plugins[@options.plugin_name] = Object.assign {}, current_config, {
      actions: actions.concat @options.command
      'create-tests': @options['create-tests']
    }
    updated_plugins = Object.assign {}, @config.get('plugins'), plugins
    @config.set 'plugins', updated_plugins


  intializing: =>

  build_action: =>
    pattern = "role:#{@options.plugin_name}, cmd:#{@options.command}"
    @log "Building #{pattern}"

  writing: =>
    plugin_opts = @config.get('plugins')[@options.plugin_name]
    plugin_opts.actions.forEach (command)=>
      @fs.copyTpl(
        @templatePath 'action_file.coffee'
        @destinationPath "src/plugins/#{@options.plugin_name}/#{command}.coffee"
        {command}
      )
      if plugin_opts['create-tests']
        @fs.copyTpl(
          @templatePath 'action_test.coffee'
          @destinationPath "test/#{@options.plugin_name}/#{command}.spec.coffee"
          {
            plugin_name: @options.plugin_name
            command
          }
        )

  conflicts: =>

  install: =>

  end: =>
