fs = require 'fs'
path = require 'path'

hamlc = require 'haml-coffee'

# Public: Base class for all page types.
module.exports =
class Page
  # Public: Constructs a new page.
  #
  # A page consists of a layout template and a content template. The layout describes the general
  # page: the header, the body, any script or style includes, etc. The content template describes
  # all of the content of the page. Layout is generally shared across the entire project or general
  # page types while content is specific to a page.
  #
  # * `templatePath` A {String} containing the path to the template to use to render the page.
  # * `locals` An {Object} of values to insert into the template when rendering.
  constructor: (templatePath, @locals) ->
    @templatePath = @normalizeTemplatePath(templatePath)

  # Public: Renders the page.
  #
  # Returns a {String} containing the rendered HTML.
  render: ->
    haml = fs.readFileSync(@templatePath).toString()
    template = hamlc.compile(haml)
    content = template(@locals)

  # Private: Rebases the path out of the `templates` directory unless a more specific path is given.
  #
  # * `templatePath` A {String} containing a filename or a path.
  #
  # Returns a path {String}.
  normalizeTemplatePath: (templatePath) ->
    if templatePath.search /\//
      path.join(path.dirname(__dirname), 'templates', templatePath)
    else
      templatePath
