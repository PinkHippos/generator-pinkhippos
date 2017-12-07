assert = require 'yeoman-assert'
yo_helpers = require 'yeoman-test'

describe 'pinkhippos:app', ->
  beforeEach ->
    yo_helpers.run "#{__dirname}/../generators/app"
  describe 'running with defaults', ->
    it "should save a .yo-rc.json file", ->
      assert.file [
        '.yo-rc.json'
      ]
    it "should write the app index file", ->
      assert.file [
        'src/index.coffee'
      ]
    it "should write the seneca instance file", ->
      assert.file [
        'src/seneca/instance.coffee'
      ]
