Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposGenerator extends Generator
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
    if @options.create_plugins
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

  # :app Helper Methods (_ prefixed fns will not be run by default)
  _update_opts: (update)=>
    @options = Object.assign {}, @options, update
  _next_numbered_name: (name, series)=>
    match = name.match /_[0-9]+$/
    number_in_series = if match
      match[0].split('_').join('')
    else
      false
    if number_in_series
      base = name.split('_')
      # Pop off the numbered suffix
      base.pop()
      next_in_series = "#{base.join '_'}_#{parseInt(number_in_series) + 1}"
    else
      next_in_series = "#{name}_1"
    if series.indexOf(next_in_series) != -1
      @_next_numbered_name next_in_series, series
    else
      next_in_series
  # :app Write Block
  writing: =>

  # :app Conflicts Block
  conflicts: =>

  # :app Install Block
  install: =>

  # :app End Block
  end: =>
