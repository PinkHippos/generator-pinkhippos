###
# @name plugins/<%= role %>/index.coffee
# Autogenerated by pinkhippos:seneca_plugin
###

module.exports = (options)->
  plugin = '<%= role %>'
  commands = [<% for(var i=0; i<actions.length; i++) {%>
    '<%= actions[i] %>'
   <% } %>]
  for cmd in commands
    pattern_string = "role:#{plugin},cmd:#{cmd}"
    @add pattern_string, require "#{__dirname}/#{cmd}"
  plugin
