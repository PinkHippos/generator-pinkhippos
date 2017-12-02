Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'
module.exports = class PinkhipposGenerator extends Generator
  constructor: (args, opts)->
    super args, opts
    message = "Running #{chalk.blue ':plugin'}"
    @argument 'plugin_role', {
      desc: 'String value that sets the role for the plugin'
      type: String
      required: false
      default: 'ph_dummy_plugin'
    }
    @argument 'create_cmds', {
      desc: 'Boolean to determine if :plugin will run :seneca_action'
      type: Boolean
      required: false
      default: true
    }
    @log yosay message
  create_plugin_cmds: =>
    if @options.create_cmds
      @composeWith require.resolve '../seneca_action'
  prompting: =>
    # Prompt set for creating new seneca actions
    # This will gather the required arguments to run sub_generators
    action_prompts = [
      {
        type: 'input'
        name: 'cmd'
        message: 'Enter the cmd for the action'
      }
    ]
    # Prompt set to gether info for setting up new plugin
    # Asks if cmds should be created and kicks off action_prompts accordingly
    plugin_option_prompts = [
      {
        type: 'input'
        name: 'role'
        message: "Enter the 'role' of the plugin:"
        default: @options.plugin_role
      }
      {
        type: 'confirm'
        name: 'create_cmds'
        message: 'Would you like to add actions now?'
        default: @options.create_cmds
      }
    ]
    @prompt plugin_option_prompts
    .then (config_answers)=>
      @log config_answers
  end: =>
    @log "Finished with #{chalk.blue ':plugin'} sub_generator"
