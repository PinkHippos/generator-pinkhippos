assert = require 'yeoman-assert'
yo_helpers = require 'yeoman-test'

describe 'pinkhippos:action', ->
  beforeEach ->
    yo_helpers.run "#{__dirname}/../generators/action"
  describe 'running with defaults', ->
    it "should write the action file", ->
      assert.file [
        'src/plugins/ph_dummy_plugin/dummy_cmd.coffee'
      ]
