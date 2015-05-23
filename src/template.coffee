fs = require 'fs'
path = require 'path'

emoji = require 'markdown-it-emoji'
hamlc = require 'haml-coffee'
highlightjs = require 'highlight.js'
MarkdownIt = require 'markdown-it'
up = require 'underscore-plus'

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
  @markdownOptions:
    highlight: (code, lang) ->
      if lang
        Template.render('highlight', content: highlightjs.highlight(lang, code).value)
      else
        code
    html: true

  @theme: 'default'

  # Public: Renders the `template` using `locals`.
  #
  # * `template` {String} name of the template to use.
  # * `locals` {Object} containing the locals to use in the template.
  # * `options` {Object}
  #     * `compiler` {Object} of `hamlc` compiler options
  #     * `markdown` Converts the listed fields from Markdown to HTML
  #     * `noParagraph` Strips the paragraph tags from fields converted from Markdown
  #     * `resolve` Resolves references in the listed fields in `locals`
  #
  # Returns a {String} containing the rendered tepmlate.
  @render: (template, locals, options) ->
    new this(template).render(locals, options)

  # Public: Creates a new `Template` object.
  #
  # * `template` Name {String} of the template to use to render the object.
  constructor: (template) ->
    @md = new MarkdownIt(Template.markdownOptions).use(emoji)
    @templatePath = @normalizeTemplatePath(template)

  # Public: Renders the page.
  #
  # * `locals` {Object} of items to insert into the template
  # * `options` {Object}
  #     * `compiler` {Object} of `hamlc` compiler options
  #     * `markdown` Converts the listed fields from Markdown to HTML
  #     * `noParagraph` Strips the paragraph tags from fields converted from Markdown
  #     * `resolve` Resolves references in the listed fields in `locals`
  #
  # Returns a {String} containing the rendered HTML.
  render: (locals, options = {}) ->
    if options.resolve
      for field in options.resolve
        locals[field] = @resolveReferences(locals[field])

    if options.markdown
      for field in options.markdown
        locals[field] = @markdownify(locals[field], noParagraph: options.noParagraph)

    haml = fs.readFileSync(@templatePath).toString()
    template = hamlc.compile(haml, options.compiler ? {escapeAttributes: false})
    content = template(locals)

    content.replace(/\n\n/, '\n')

  # Public: Converts the supplied Markdown content into HTML.
  #
  # * `content` Markdown content {String}.
  # * `options` {Object}
  #     * `noParagraph` If `true` it will strip any HTML paragraph tags.
  #
  # Returns a {String} containing the generated HTML.
  markdownify: (content, options = {}) ->
    return '' unless content
    output = @md.render(content, Template.markedOptions)
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

  # Private: Resolves a single reference.
  #
  # * `ref` {String} containing a documentation reference.
  #
  # Returns the link {String} to the appropriate documentation if it is a valid reference.
  # Returns the input {String} if the reference is invalid.
  resolveReference: (ref) ->
    result = Resolver.getInstance().resolve(ref)
    if typeof result is 'string'
      result
    else
      template = new Template('reference')
      template.render(result)

  # Private: Strips paragraph tags from the text.
  #
  # * `content` {String} to remove the tags from.
  #
  # Returns the {String} with the tags removed.
  stripParagraphTags: (content) ->
    content.replace(/<\/?p>/g, '')

  # Private: Rebases the path out of the `templates` directory unless a more specific path is given.
  #
  # * `templatePath` A {String} containing a filename or a path.
  #
  # Returns a path {String}.
  normalizeTemplatePath: (templatePath) ->
    templatePath += '.haml' if path.extname(templatePath) is ''

    if templatePath.search(/\//) is -1
      path.join(path.dirname(__dirname), 'themes', Template.theme, 'templates', templatePath)
    else
      templatePath

module.exports = Template
