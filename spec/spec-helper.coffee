fs = require 'fs'
path = require 'path'

module.exports =
  getFixturePath: (name) ->
    path.join(__dirname, 'fixtures', name)

  getFixtureText: (name) ->
    fs.readFileSync(@getFixturePath(name)).toString()
