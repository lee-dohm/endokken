fs = require 'fs'
path = require 'path'

hamlc = require 'haml-coffee'
highlightjs = require 'highlight.js'
marked = require 'marked'

# Public: Used to render a HAML template into an HTML document.
#
# ## Examples
#
# Basic usage.
#
# ```coffee
# Template.render('some-template', foo: 'bar')
# ```
module.exports =
class Template
  @markedOptions:
    gfm: true
    highlight: (code) ->
      "<div class=\"hljs\">#{highlightjs.highlightAuto(code).value}</div>"
    smartypants: true

  @render: (template, locals) ->
    new this(template, locals).render()

  # Public: Creates a new `Template` object.
  #
  # * `template` Name {String} of the template to use to render the object.
  # * `locals` {Object} of items to insert into the template
  constructor: (template, @locals) ->
    @templatePath = @normalizeTemplatePath(template)

  markdownify: (content) ->
    marked(content, Template.markedOptions)

  # Public: Renders the page.
  #
  # Returns a {String} containing the rendered HTML.
  render: ->
    haml = fs.readFileSync(@templatePath).toString()
    template = hamlc.compile(haml)
    content = template(@locals)

    content.replace(/\n\n/, '\n')

  # Private: Rebases the path out of the `templates` directory unless a more specific path is given.
  #
  # * `templatePath` A {String} containing a filename or a path.
  #
  # Returns a path {String}.
  normalizeTemplatePath: (templatePath) ->
    templatePath += '.haml' if path.extname(templatePath) is ''

    if templatePath.search /\//
      path.join(path.dirname(__dirname), 'templates', templatePath)
    else
      templatePath
