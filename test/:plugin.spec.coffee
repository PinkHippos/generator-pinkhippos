assert = require 'yeoman-assert'
yo_helpers = require 'yeoman-test'

describe 'pinkhippos:action', ->
  beforeEach ->
    yo_helpers.run "#{__dirname}/../generators/plugin"
  describe 'running with defaults', ->
    it "should write the plugin index file", ->
      assert.file [
        'src/plugins/ph_dummy_plugin/index.coffee'
      ]
