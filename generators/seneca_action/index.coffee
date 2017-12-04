PinkHipposPluginGenerator = require '../seneca_plugin'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposSenecaActionGenerator extends PinkHipposPluginGenerator

  constructor: (args, opts)->
    super args, opts
    # @log "Constructing :seneca_action generator"
    @argument 'plugin_name', {
      type: String
      description: 'The name of the plugin to add actions to.'
      default: @options.plugin_name
    }
    @argument 'action_cmd', {
      type: String
      description: 'The value for the cmd of the action.'
      default: @options.action_cmd ? 'dummy_cmd'
      required: false
    }
  prompting: =>
    @log "Prompting :seneca_action"

  configuring: =>
    @log "Configuring :seneca_action for #{@options.plugin_name}"
    current_config = @config.get('plugins')[@options.plugin_name] ? {}
    actions = current_config.actions ? []
    if actions.indexOf(@options.action_cmd) != -1
      @options.action_cmd = @_next_numbered_name @options.action_cmd, actions
    plugins = {}
    plugins[@options.plugin_name] = Object.assign {}, current_config, {
      actions: actions.concat @options.action_cmd
    }
    updated_plugins = Object.assign {}, @config.get('plugins'), plugins
    @config.set 'plugins', updated_plugins


  intializing: =>
    @log "Intializing :seneca_action"

  build_action: =>
    pattern = "role:#{@options.plugin_name}, cmd:#{@options.action_cmd}"
    @log "Building #{pattern} in :seneca_action"

  writing: =>
    @log "Writing files for :seneca_action"

  conflicts: =>
    @log "Handling conflicts for :seneca_action"

  install: =>
    @log "Running install for :seneca_action"

  end: =>
    @log "All done in :seneca_action"






  # constructor: (args, opts)->
  #   super args, opts
  #   message = "Running #{chalk.blue ':seneca_action'}"
  #   @argument 'action_cmd', {
  #     description: 'String value that sets the cmd for the action'
  #     type: String
  #     required: false
  #     default: 'ph_dummy_cmd'
  #   }
  #   @log yosay message
  # _created_actions: []
  # writing: =>
  #   pattern = "role:#{@options.plugin_role},cmd:#{@options.action_cmd}"
  #   @log "Writing action files for #{pattern}"
  #   @_created_actions.push pattern
  # end: =>
  #   done = @async()
  #   @prompt [{
  #     type: 'confirm'
  #     name: 'create_another'
  #     message: 'Would you like to create another action?'
  #     default: false
  #   }]
  #   .then (follow_answer)=>
  #     if follow_answer.create_another
  #       @prompt [{
  #         type: 'input'
  #         name: 'action_cmd'
  #         message: 'Enter the name of the next cmd'
  #         default: "#{@options.action_cmd}_#{@_created_actions.length}"
  #         }]
  #         .then (cmd_answer)=>
  #           @run done
  #     else
  #       config_actions = @config.get 'created_actions'
  #       if !config_actions then config_actions = []
  #       all_actions = config_actions.concat @_created_actions
  #       @log 'All Actions', all_actions
  #       @config.set 'created_actions', all_actions
  #       @log yosay "Created #{@_created_actions.length} new action(s)"
  #       done()
