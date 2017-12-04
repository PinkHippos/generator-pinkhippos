PinkHipposGenerator = require '../app'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposPluginGenerator extends PinkHipposGenerator
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
    @options.plugins = (@options.plugins ? @config.get('plugins')) or {}
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

  # :seneca_plugin Configure Block
  configuring: =>
    @config.set 'plugins', Object.assign {}, @config.get('plugins'), @options.plugins


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

  # :seneca_plugin Queued Helpers Block (these are run by default)

  # :seneca_plugin Util Helper Methods Block (prefixed by _ aren't run by default)

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

  # :seneca_plugin Conflicts Block
  conflicts: =>

  # :seneca_plugin Install Block
  install: =>

  # :seneca_plugin End Block
  end: =>


  # constructor: (args, opts)->
  #   super args, opts
  #   message = "Running #{chalk.blue ':plugin'}"
  #   # Reset the created actions before creating the plugin
  #   @config.set 'created_actions', []
  #   @argument 'plugin_role', {
  #     description: 'String value that sets the role for the plugin'
  #     type: String
  #     required: false
  #     default: 'ph_dummy_plugin'
  #   }
  #   @argument 'create_cmds', {
  #     description: 'Boolean to determine if :plugin will run :seneca_action'
  #     type: Boolean
  #     required: false
  #     default: true
  #   }
  #   @log yosay message
  # _created_plugins: []
  # prompting: =>
  #   # Prompt set to gether info for setting up new plugin
  #   # Asks if cmds should be created and kicks off action_prompts accordingly
  #   plugin_option_prompts = [
  #     {
  #       type: 'input'
  #       name: 'plugin_role'
  #       message: "Enter the 'role' of the plugin:"
  #       default: "#{@options.plugin_role}"
  #       validate: (input)=>
  #         if !input or typeof(input) != 'string'
  #           @log chalk.red 'Enter a value for the plugin role'
  #           false
  #         else
  #           true
  #     }
  #     {
  #       type: 'confirm'
  #       name: 'create_cmds'
  #       message: 'Would you like to add actions for that plugin now?'
  #       default: @options.create_cmds
  #     }
  #   ]
  #   @prompt plugin_option_prompts
  #   .then (user_answers)=>
  #     @options = Object.assign {}, @options, user_answers
  # writing: =>
  #   done = @async()
  #   @log "Writing files for plugin with role: '#{@options.plugin_role}'"
  #   @_created_plugins.push "role:#{@options.plugin_role}"
  #   if @options.create_cmds
  #     Action_generator = require '../seneca_action'
  #     new Action_generator @options
  #       .run done
  #   else
  #     done()
  #
  # _prompt_for_another: =>
  #   done = @async()
  #   @prompt [{
  #     type: 'confirm'
  #     name: 'create_another'
  #     message: 'Would you like to create another plugin?'
  #     default: false
  #     }]
  #     .then (plugin_answer)=>
  #       if plugin_answer.create_another
  #         @run done
  #       else
  #         config_plugins = @config.get 'created_plugins'
  #         if !config_plugins then config_plugins = []
  #         all_plugins = config_plugins.concat @_created_plugins
  #         @log 'All plugins', all_plugins
  #         @config.set 'created_plugins', all_plugins
  #         @log yosay "Created #{@_created_plugins.length} new plugin(s)"
  #         done()
  #
  # end: =>
  #   @_prompt_for_another()
