###
# @name plugins/<%= plugin_name %>/index.coffee
# Autogenerated by pinkhippos:seneca_plugin
###

module.exports = (options)->
  plugin = '<%= plugin_name%>'
  commands = [<% for(var i=0; i<actions.length; i++) {%>
    '<%= actions[i] %>'
   <% } %>]
  for cmd in commands
    pattern_string = "role:#{plugin},cmd:#{cmd}"
    @add pattern_string, require "#{__dirname}/#{cmd}"
  plugin