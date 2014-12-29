fs = require 'fs'
path = require 'path'

Template = require './template'

# Public: Used to render a documentation file like `README.md`.
class FilePage extends Template
  @render: (filePath) ->
    new this(filePath).render()

  constructor: (@filePath) ->

  render: ->
    console.log("File: #{path.basename(@filePath, path.extname(@filePath))}")
    @markdownify(fs.readFileSync(@filePath).toString())

module.exports = FilePage
