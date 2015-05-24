fs = require 'fs'
path = require 'path'

Template = require './template'

# Public: Used to render a documentation file like `README.md`.
class FilePage extends Template
  ###
  Section: Simplified Interface

  Used to simply render the content in one step.
  ###

  # Public: Renders the file stored at `filePath`.
  #
  # * `filePath` {String} containing the path to the file to be rendered.
  #
  # Returns a {String} containing the rendered content.
  @render: (filePath) ->
    new this(filePath).render()

  ###
  Section: Customizable Interface
  ###

  # Public: Constructs a new `FilePage` for the `filePath`.
  #
  # * `filePath` {String} containing the path to the file to be rendered.
  constructor: (@filePath) ->
    super()

  # Public: Renders the file.
  #
  # Returns a {String} containing the rendered content.
  render: ->
    name = path.basename(@filePath, path.extname(@filePath))
    console.log("File: #{name}")

    contents = fs.readFileSync(@filePath).toString()
    firstLine = contents.split("\n")[0]

    if path.extname(@filePath) is '.md' and not firstLine.match(/^#\s/)
      console.log("Generating header: #{name}")
      contents = "# #{name}\n#{contents}"

    @markdownify(@resolveReferences(contents))

module.exports = FilePage
