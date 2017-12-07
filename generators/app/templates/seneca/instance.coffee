###
# @name instance
# @description Exports a seneca instance with amqp-transport
# Generated by pinkhippos:app
###

seneca = require 'seneca'

rabbit_user = process.env.PH_RABBIT_USER ? 'guest'
rabbit_pass = process.env.PH_RABBIT_PASS ? 'guest'

# Add any options used across the plugins here
instance_options =
  log:
    level: true
  tag: '<%= service_name %>'

base_instance = seneca instance_options
  .use 'seneca-amqp-transport', {
    amqp:
      url: "amqp://#{credentials}@rabbitmq:5672"
  }
  .client {
    type: 'amqp'
    pin: 'role:*,cmd:*'
  }
module.exports = base_instance