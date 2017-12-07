Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposPluginGenerator extends Generator
  ####
  # :seneca_plugin Constructor Block
  constructor: (args, opts)->
    super args, opts
    # @log "Constructing :seneca_plugin generator"
    @argument 'role', {
      type: String
      description: "Sets the 'role' key for the plugin that will be generated"
      default: 'ph_dummy_plugin'
    }
  ####
  # :seneca_plugin Prompt Block
  prompting: =>

  ####
  # :seneca_plugin Configure Block
  configuring: =>
    @config.defaults {
      plugins:
        "#{@options.role}": {}
    }
  ####
  # :seneca_plugin Intializing Block
  intializing: =>

  ####
  # :seneca_plugin Queued Helpers Block (these are run by default)

  ####
  # :seneca_plugin Util Helper Methods Block (prefixed by _ aren't run by default)

  ####
  # :seneca_plugin Writing Block
  writing: =>
    plugins = @config.get 'plugins'
    actions = plugins[@options.role].actions ? []
    @fs.copyTpl(
      @templatePath 'plugin_index.coffee'
      @destinationPath "src/plugins/#{@options.role}/index.coffee"
      {
        role: @options.role
        actions
      }
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
