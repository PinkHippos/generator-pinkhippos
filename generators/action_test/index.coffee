Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'

module.exports = class PinkHipposSenecaActionTestGenerator extends Generator

  constructor: (args, opts)->
    super args, opts
    # @log "Constructing :action_test generator"
    @argument 'role', {
      type: String
      description: 'The role value of the plugin to that holds the action to be tested.'
      default: 'ph_dummy_plugin'
    }
    @argument 'command', {
      type: String
      description: 'The value for the cmd of the action to be tested.'
      default: 'dummy_cmd'
    }
    @option 'prompt', {
      type: Boolean
      description: 'If the generator should prompt for answers or use defaults'
      default: false
      required: false
    }

  prompting: =>
    # @prompt [
    #   {
    #     type: 'input'
    #     name: 'role'
    #     message: 'Enter the role value of the plugin to be tested'
    #     default: @options.role
    #     when: !@options['no-prompt']
    #   }
    #   {
    #     type: 'input'
    #     name: 'command'
    #     message: 'Enter the cmd of the action to be tested'
    #     default: @options.command
    #     when: !@options['no-prompt']
    #   }
    # ]
    # .then (answers)=>


  configuring: =>

  intializing: =>

  writing: =>
    @fs.copyTpl(
      @templatePath 'action_test.coffee'
      @destinationPath "test/#{@options.role}/#{@options.command}.spec.coffee"
      {
        role: @options.role
        command: @options.command
      }
    )

  conflicts: =>

  install: =>

  end: =>
