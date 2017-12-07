seneca = require "#{__dirname}/seneca/instance"
version = process.env.<%= service_name.toUpperCase() %>_V or 'X.X.X'
listener = seneca
  .use '/plugins/SOME_PLUGIN_NAME'
  .ready (err)->
    if err
      args =
        role: 'util'
        cmd: 'handle_err'
        service: 'system'
        message: 'Error with starting seneca listener in system'
        err: err
    else
      base =
        type: 'amqp'
        pins: [
          'role:SOME_PLUGIN_NAME,cmd:*'
        ]
      listener.listen base
      args =
        role: 'util'
        cmd: 'log'
        service: '<%= service_name %>'
        type: 'general'
        message: "<%= service_name %> v#{version} started"
      @act args
