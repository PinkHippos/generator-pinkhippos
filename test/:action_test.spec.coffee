assert = require 'yeoman-assert'
yo_helpers = require 'yeoman-test'

describe 'pinkhippos:action_test', ->
  beforeEach ->
    yo_helpers.run "#{__dirname}/../generators/action_test"
  describe 'running with defaults', ->
    it "should write the test file", ->
      assert.file [
        'test/ph_dummy_plugin/dummy_cmd.spec.coffee'
      ]
    it "should include the proper role and command", ->
      assert.fileContent 'test/ph_dummy_plugin/dummy_cmd.spec.coffee',
        """
        default_action_opts =
          role: 'ph_dummy_plugin'
          cmd: 'dummy_cmd'
        """
