fs = require 'fs'
path = require 'path'

hamlc = require 'haml-coffee'

# Public: Base class for all page types.
module.exports =
class Page
  # Public: Constructs a new page.
  #
  # * `templatePath` A {String} containing the path to the template to use to render the page.
  # * `locals` An {Object} of values to insert into the template when rendering.
  constructor: (@templatePath, @locals) ->
    if @templatePath.search /\//
      @templatePath = path.join(path.dirname(__dirname), 'templates', @templatePath)

  # Public: Renders the page.
  #
  # Returns a {String} containing the rendered HTML.
  render: ->
    haml = fs.readFileSync(@templatePath).toString()
    template = hamlc.compile(haml)
    template(@locals)
