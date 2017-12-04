moment = require 'moment'
seneca = require 'seneca'
sinon = require 'sinon'

# Calls 'done' callback of a stubbed seneca action
# use ACTION_STUB.calls_done_with and pass an object {err, response}
# stub will call arg[1], which is the done cb, with err and response passed in
#   *EXAMPLE*
#   missing_args_stub = get_action_stub()
#   stub_done_response =
#     response:
#       foo: 'bar'
#   missing_args_stub.calls_done_with stub_done_response
#   @act MISSING_ARGS_PATTERN, (err, response)->
#     console.log response ====> {foo:'bar'}
sinon.addBehavior 'calls_done_with', (stub_instance, args)->
  {err, response} = args
  stub_instance.callsArgWith 1, err, response

module.exports =
  # Returns a date
  get_dynamic_date: (days_from_now)->
    formatted_date = moment()
      .subtract days_from_now, 'days'
      .format 'MM/DD/YYYY'
    formatted_date
  # Returns a fresh seneca instance after calling .use with given plugins
  fresh_instance: (done, plugins)->
    instance = seneca log: 'test'
    instance
      .test done
    for plugin in plugins
      instance.use plugin
    instance
  stubs:
    # Resets a map of stubs and returns the reset map
    reset_stubs: (stubs)->
      for stub of stubs
        stubs[stub].reset()
      stubs
    # Returns a stub with some extra magic for seneca actions
    get_action_stub: (stub)->
      sinon.stub()
    # Returns the 'args' passed to a stubbed seneca action
    # use get_action_args(ACTION_STUB, call_number) to return the args passed to the ACTION_STUB
    # pass a 0-indexed call_number to get the action_args from the given call
    #     MISSING_ARGS_PATTERN =
    #       baz: 'bat'
    #     @act MISSING_ARGS_PATTERN
    #     first_call_args = get_action_args missing_args_stub
    #     console.log first_call_args ====> {baz:'bat'}
    #     MISSING_ARGS_PATTERN =
    #       tap: 'tar'
    #     @act MISSING_ARGS_PATTERN
    #     second_call_args = get_action_args missing_args_stub, 1
    #     console.log first_call_args ====> {tap:'tar'}
    get_action_args: (stub_instance, call_number = 0)->
      stub_instance.getCall(call_number).args[0]
