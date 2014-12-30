fs = require 'fs'
path = require 'path'

hamlc = require 'haml-coffee'
highlightjs = require 'highlight.js'
marked = require 'marked'

Resolver = require './resolver'

# Public: Used to render a HAML template into an HTML document.
#
# It uses [haml-coffee](https://www.npmjs.com/package/haml-coffee) to render the HAML template into
# HTML. See the documentation for haml-coffee for full details on the dialect in use.
#
# ## Examples
#
# Basic usage:
#
# ```coffee
# Template.render('some-template', foo: 'bar')
# ```
#
# Templates can also be used to render portions of pages and then the results passed in:
#
# ```coffee
# section = Template.render('page-section', content: 'Some content to include')
# fullPage = Template.render('full-page', section: section)
# ```
class Template
  @markedOptions:
    gfm: true
    highlight: (code, lang) ->
      Template.render('highlight', content: highlightjs.highlight(lang, code).value)
    smartypants: true

  # Public: Renders the `template` using `locals`.
  #
  # * `template` {String} name of the template to use.
  # * `locals` {Object} containing the locals to use in the template.
  #
  # Returns a {String} containing the rendered tepmlate.
  @render: (template, locals) ->
    new this(template, locals).render()

  # Public: Creates a new `Template` object.
  #
  # * `template` Name {String} of the template to use to render the object.
  # * `locals` {Object} of items to insert into the template
  constructor: (template, @locals) ->
    @templatePath = @normalizeTemplatePath(template)

  # Public: Renders the page.
  #
  # Returns a {String} containing the rendered HTML.
  render: ->
    haml = fs.readFileSync(@templatePath).toString()
    template = hamlc.compile(haml)
    content = template(@locals)

    content.replace(/\n\n/, '\n')

  # Public: Converts the supplied Markdown content into HTML.
  #
  # * `content` Markdown content {String}.
  # * `options` {Object}
  #     * `noParagraph` If `true` it will strip the outermost HTML paragraph tags.
  #
  # Returns a {String} containing the generated HTML.
  markdownify: (content, options = {}) ->
    return '' unless content
    output = marked(content, Template.markedOptions)
    output = @stripParagraphTags(output) if options.noParagraph
    output

  # Public: Resolves references to other documentation.
  #
  # Uses {Resolver} to convert any documentation references found.
  #
  # * `text` {String} to search for references.
  #
  # Returns a {String} with all documentation references turned into links.
  resolveReferences: (text) ->
    text?.replace /`?\{\S*\}`?/g, (match) =>
      return match if match.match(/^`.*`$/)
      @resolveReference(match)

  resolveReference: (ref) ->
    result = Resolver.getInstance().resolve(ref)
    if typeof result is 'string'
      result
    else
      Template.render('reference', result)

  stripParagraphTags: (content) ->
    content.replace(/<\/?p>/g, '')

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

module.exports = Template
