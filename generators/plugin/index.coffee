PinkHipposGenerator = require '../app'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposPluginGenerator extends PinkHipposGenerator
  ####
  # :seneca_plugin Constructor Block
  constructor: (args, opts)->
    super args, opts
    # @log "Constructing :seneca_plugin generator"
    @option 'role', {
      type: String
      description: "Sets the 'role' key for the plugin that will be generated"
      default: @options.role ? @config.get 'default_plugin_role'
    }
    @option 'create-actions', {
      type: (input)->
        if input is 'false'
          input = false
        else
          input = true
        input
      description: 'Determines if actions will be created for the plugins'
      default: true
      required: false
    }
    @option 'create-tests', {
      type: (input)->
        if input is 'false'
          input = false
        else
          input = true
        input
      description: 'Determines if a test file will be generated for the action.'
      default: true
    }
    @options.plugins = (@options.plugins ? @config.get('plugins')) or {}
  ####
  # :seneca_plugin Prompt Block
  prompting: =>
    @log "Prompting :seneca_plugin"
    role_prompt =
      name: 'role'
      type: 'input'
      message: "Enter the 'role' for the plugin"
      default: @options.role
      when: =>
        if @options.role and @options.role != @config.get 'default_plugin_role'
          false
        else
          true
    action_prompt =
      name: 'create-actions'
      type: 'confirm'
      message: "Would you like to create actions for the plugin?"
      default: @options['create-actions']
    config_prompts = [
      role_prompt
      action_prompt
    ]
    @prompt config_prompts
    .then (answers)=>
      role = answers.role ? @options.role
      plugins = @options.plugins
      if plugins.hasOwnProperty role
        role = @_next_numbered_name role, Object.keys plugins
      plugins[role] =
        'create-actions': answers['create-actions'] ? @options['create-actions']
      @_update_opts {plugins}
      @prompt [{
        type: 'confirm'
        name: 'create_another'
        message: 'Would you like to create another plugin?'
        default: false
      }]
      .then (answers)=>
        if answers.create_another
          @prompting()
        else
          @log yosay "Plugins to be created #{Object.keys(@options.plugins).join ', '}"
  ####
  # :seneca_plugin Configure Block
  configuring: =>
    @config.set 'plugins', Object.assign {}, @config.get('plugins'), @options.plugins

  ####
  # :seneca_plugin Intializing Block
  intializing: =>
    keys = Object.keys(@config.get 'plugins')
    with_actions_count = 0
    keys.forEach (plugin_name)=>
      plugin_opts = @config.get('plugins')[plugin_name]
      if plugin_opts['create-actions']
        with_actions_count++
        @composeWith 'pinkhippos:seneca_action', {
          plugin_name
        }
    @log yosay """
    Creating #{keys.length} plugin(s),
    #{with_actions_count} with actions
    """
  ####
  # :seneca_plugin Queued Helpers Block (these are run by default)

  ####
  # :seneca_plugin Util Helper Methods Block (prefixed by _ aren't run by default)

  ####
  # :seneca_plugin Writing Block
  writing: =>
    plugins = @config.get 'plugins'
    Object.keys(plugins).forEach (plugin_name)=>
      actions = plugins[plugin_name].actions ? []
      @fs.copyTpl(
        @templatePath 'plugin_index.coffee'
        @destinationPath "src/plugins/#{plugin_name}/index.coffee"
        {plugin_name, actions}
      )

  ####
  # :seneca_plugin Conflicts Block
  conflicts: =>

  ####
  # :seneca_plugin Install Block
  install: =>

  ####
  # :seneca_plugin End Block
  end: =>
