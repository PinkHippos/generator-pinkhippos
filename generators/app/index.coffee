Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposGenerator extends Generator
  # :app Constructor Block
  constructor: (args, options)->
    super args, options
    # Create a .yo-rc.json entry for the pinkhippos generator
    @config.save()
    # Set any argument & option definitions for the generator here
    @argument 'service_name', {
      type: String
      description: 'Sets the service name in the index and instance files'
      default: @appname
    }
    @option 'plugins', {
      type: Boolean
      description: 'Determines if plugins will be created'
      default: false
    }
    @option 'actions', {
      type: Boolean
      description: 'Determines if actions will be created for the plugins'
      default: false
    }

  # :app Prompt Block
  prompting: =>
    # @log "Prompting :app"

  # :app Configure Block
  configuring: =>
    @config.defaults {
      plugins: {}
    }
  # :app Initialize Block
  intializing: =>

  # :app Helper Methods (_ prefixed fns will not be run by default)
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
    @fs.copyTpl(
      @templatePath 'app_index.coffee'
      @destinationPath "src/index.coffee"
      {
        service_name: @options.service_name
      }
    )
    @fs.copyTpl(
      @templatePath 'seneca/instance.coffee'
      @destinationPath "src/seneca/instance.coffee"
      {
        service_name: @options.service_name
      }
    )

  # :app Conflicts Block
  conflicts: =>

  # :app Install Block
  install: =>

  # :app End Block
  end: =>
