{expect} = require 'chai'
seneca = require 'seneca'
sinon = require 'sinon'
proxyquire = require 'proxyquire'

test_helpers = require "#{__dirname}/../_test_helpers"
{fresh_instance, get_dynamic_date} = test_helpers
{reset_stubs, get_action_stub, get_action_args} = test_helpers.stubs

# Create any stubs here
_stubs =
  dummy_action_stub: get_action_stub()
  dummy_fn_stub: sinon.stub()

_fresh_instance = (done)->
  # Using proxyquire here so we can stub out the required helper files
  action_file_with_stubs = proxyquire "#{__dirname}/../../src/plugins/<%= plugin_name %>/<%= command %>", {
    './dummy_fn': _stubs.dummy_fn_stub
  }
  # Use proxquire again here so we are using the action file that's got stubbed helpers
  plugin_in_test = proxyquire "#{__dirname}/../../src/plugins/<%= plugin_name %>", {
    './<%= command %>': action_file_with_stubs
  }
  # Set up plugin with stubbed out seneca actions
  mock_plugin = (options)->
    @add 'role:foo,cmd:bar', _stubs.dummy_action_stub
  # return a seneca instance that uses the given plugins
  test_helpers.fresh_instance done, [plugin_in_test, mock_plugin]

default_action_opts =
  role: '<%= plugin_name %>'
  cmd: '<%= command %>'

describe '|--- role: <%= plugin_name %> cmd: <%= command %> ---|', ->

  describe 'bootstrapping', ->
    test_instance = null
    before 'save test instance once ready', (done)->
      test_instance = _fresh_instance done
        .ready ->
          done()
    it "has the pattern '<%= command %>'", ->
      pattern = 'role:<%= plugin_name %>,cmd:<%= command %>'
      has_pattern = test_instance.has pattern
      expect(has_pattern).to.equal true

  describe 'handling bad args', ->
    bad_args_tests =
      BAD_TEST_NAME:
        SOME_REQUIRED_ARG: null
    Object.keys(bad_args_tests).forEach (test_name)->
      describe test_name, ->
        result = null
        bad_args = Object.assign {}, default_action_opts, bad_args_tests[test_name]
        beforeEach 'send action and save result', (done)->
          _stubs.missing_args.calls_done_with {
            response: data: {}
          }
          _fresh_instance done
          .ready ->
            @act bad_args, (err, response)->
              result = response
              done()
        afterEach 'reset stubs', ->
          _stubs = reset_stubs _stubs
        it "should return an object", ->
          expect(result).to.be.an 'object'
        it "should send an 'err' key", ->
          expect(result).to.include.keys 'err'
        it "should call 'missing_args'", ->
          expect(_stubs.missing_args.called).to.equal true
        it "should pass a 'given' key to missing_args", ->
          expect(get_action_args(_stubs.missing_args)).to.include.keys [
            'given'
          ]

  describe 'handling good args', ->
    default_helper_returns =
      DUMMY_FN:
        FOO: 'bar'
    good_args_tests =
      default_test:
        input:
          action_opts: default_action_opts
          helper_returns: default_helper_returns
        expected:
          data:
            foo: 'bar'
            baz: true
            bat:
              tap: 'tar'

    Object.keys(good_args_tests).forEach (test_name)->
      describe test_name, ->
        result = null
        {input, expected} = good_args_tests[test_name]
        {action_opts, helper_returns} = input
        beforeEach 'send action and save response', (done)->
          for stub_name, stub_return of helper_returns
            _stubs[stub_name].returns stub_return
          _fresh_instance done
          .ready ->
            @act action_opts, (err, response)->
              result = response
              done()
        afterEach 'reset stubs', ->
          _stubs = reset_stubs _stubs
        describe 'when calling helper functions', ->
          it "should call 'DUMMY_FN' once", ->
            {start_date, end_date} = action_opts
            stub = _stubs.dummy_fn_stub
            expect(stub.called).to.equal true
        describe 'returning properly', ->
          it "should return an object", ->
            expect(result).to.be.an 'object'
          it "should include a 'data' key", ->
            expect(result).to.include.keys 'data'
          it "should format the data as an object", ->
            expect(result.data).to.be.an 'object'
          describe 'returning the correct data', ->
            for key, val of expected.data
              it "should set the '#{key}' key correctly", ->
                expect(result[key]).to.deep.equal expected[key]
