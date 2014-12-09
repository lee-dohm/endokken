path = require 'path'

module.exports =
  getFixturePath: (name) ->
    path.join(__dirname, 'fixtures', name)
