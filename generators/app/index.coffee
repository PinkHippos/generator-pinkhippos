Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposGenerator extends Generator
  # :app Helper Methods
  _update_opts: (update)=>
    @log "Updating options with #{JSON.stringify update}"
    @options = Object.assign {}, @options, update

  # :app Constructor Block
  constructor: (args, options)->
    super args, options
    @config.save()
    # Set any argument definitions for the generator here
    @argument 'create_plugins', {
      type: Boolean
      description: 'Determines if plugins will be created for the app'
      default: @options.create_plugins ? @config.get 'create_plugins'
      required: false
    }
    @argument 'default_plugin_role', {
      type: String
      description: 'Sets the default role for any plugins generated'
      default: (@options.default_plugin_role ? @config.get 'default_plugin_role') or 'ph_dummy_plugin'
      required: false
    }
  # :app Prompt Block
  prompting: =>
    @log "Prompting :app"
    create_plugins_prompt =
      name: 'create_plugins'
      type: 'confirm'
      default: @options.create_plugins
      message: 'Do you want to create plugins now?'
    default_role_prompt =
      name: 'default_plugin_role'
      type: 'input'
      default: @options.default_plugin_role
      message: "What would you like the default plugin 'role' to be?"
      when: (answers)=>
        answers.create_plugins
    @prompt [
      create_plugins_prompt
      default_role_prompt
    ]
    .then (answers)=>
      opts_update =
        create_plugins: answers.create_plugins ? create_plugins_prompt.default
        default_plugin_role: answers.default_plugin_role ? default_role_prompt.default
      @_update_opts opts_update

  # :app Configure Block
  configuring: =>
    @log "Configuring :app"
    if @options.create_plugins
      @log "Setting configuration to create plugins"
      @config.set {
        create_plugins: @options.create_plugins
        default_plugin_role: @options.default_plugin_role
      }
      @composeWith 'pinkhippos:seneca_plugin', {
        role: @config.get 'default_plugin_role'
        create_actions: @config.get 'create_actions'
      }


  # :app Initialize Block
  intializing: =>
    @log "Intializing :app"

  # :app Write Block
  writing: =>
    @log "Writing files for :app"

  # :app Conflicts Block
  conflicts: =>
    @log "Handling conflicts for :app"

  # :app Install Block
  install: =>
    @log "Running install for :app"

  # :app End Block
  end: =>
    @log "All done in :app"
