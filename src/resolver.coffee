mozillaBaseUrl = 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects'

# Public: Used to resolve references in documentation into links to further documentation.
#
# It supports the following reference types:
#
# * Class - `{ClassName}`
# * Static method/property - `{ClassName.methodName}`
# * Instance method/property - `{ClassName::methodName}`
# * Local static item - `{.methodName}`
# * Local instance item - `{::methodName}`
#
# These references can be either project-local or external to the project. Most external references
# will be to [MDN](https://developer.mozilla.org).
#
# * Project-local references
#     * Class - links to `ClassName`
#     * Static method - links to `ClassName#static-methodName`
#     * Instance method - links to `ClassName#instance-methodName`
#     * Local static item - links to `#static-methodName`
#     * Local instance item - links to `#instance-methodName`
# * External references
#     * Class - links to `baseUrl/ClassName`
#     * Static method - links to `baseUrl/ClassName/methodName`
#     * Instance method - links to `baseUrl/ClassName/methodName`
class Resolver
  instance = null

  @getInstance: ->
    instance ?= new this({})

  @setMetadata: (metadata) ->
    @getInstance().metadata = metadata

  # Public: Initializes the resolver using the project `metadata`.
  #
  # It also initializes the basic MDN references.
  #
  # * `metadata` Documentation metadata from the project.
  constructor: (@metadata) ->
    @map = {}
    @initializeBasics()

  # Public: Adds an external reference.
  #
  # * `name` {String} to match.
  # * `url` URL {String} to resolve to.
  add: (name, url) ->
    @map[name] = url

  # Public: Resolves a documentation reference to a link name and url.
  #
  # * `text` {String} containing a documentation reference.
  #
  # Returns a {String} containing the original text if no match is found.
  # Returns an {Object} if a match is found that contains the following fields:
  # * `name` Link text {String}.
  # * `url` Link URL {String}.
  resolve: (text) ->
    itemText = text.replace(/\{(.*)\}/, '$1')

    if itemText.indexOf('.') isnt -1
      type = 'static'
      [klass, item] = itemText.split('.')
    else if itemText.indexOf('::') isnt -1
      type = 'instance'
      [klass, item] = itemText.split('::')

    switch type
      when 'static' then @resolveStatic(klass, item, itemText)
      when 'instance' then @resolveInstance(klass, item, itemText)
      else @resolveClass(itemText, text)

  # Private: Resolves a reference to a static item.
  #
  # * `klass` Class name {String}.
  # * `item` Static item name {String}.
  # * `text` Original reference {String}.
  #
  # Returns an {Object} that contains the following fields:
  #     * `name` Link text {String}.
  #     * `url` Link URL {String}.
  resolveStatic: (klass, item, text) ->
    switch
      when klass is '' then { name: text, url: "#static-#{item}" }
      when @metadata.classes[klass] then { name: text, url: "#{klass}#static-#{item}" }
      when @map[klass] then { name: text, url: "#{mozillaBaseUrl}/#{klass}/#{item}" }

  # Private: Resolves a reference to an instance item.
  #
  # * `klass` Class name {String}.
  # * `item` Instance item name {String}.
  # * `text` Original reference {String}.
  #
  # Returns an {Object} that contains the following fields:
  #     * `name` Link text {String}.
  #     * `url` Link URL {String}.
  resolveInstance: (klass, item, text) ->
    switch
      when klass is '' then { name: text, url: "#instance-#{item}" }
      when @metadata.classes[klass] then { name: text, url: "#{klass}#instance-#{item}" }
      when @map[klass] then { name: text, url: "#{mozillaBaseUrl}/#{klass}/#{item}" }

  # Private: Resolves a reference to a class.
  #
  # * `klass` Class name {String}.
  # * `item` Instance item name {String}.
  # * `text` Original reference {String}.
  #
  # Returns an {Object} that contains the following fields:
  #     * `name` Link text {String}.
  #     * `url` Link URL {String}.
  resolveClass: (klass, text) ->
    switch
      when @metadata.classes[klass]
        { name: klass, url: klass}
      when @map[klass]
        { name: klass, url: @map[klass] }
      else text

  # Private: Initializes references to basic JavaScript classes.
  initializeBasics: ->
    basics = [
      'Object'
      'String'
      'Array'
      'Function'
      'Boolean'
      'Symbol'
      'Error'
      'Number'
      'Date'
      'RegExp'
      'Infinity'
      'NaN'
      'undefined'
      'null'
    ]

    @map[item] = "#{mozillaBaseUrl}/#{item}" for item in basics

module.exports = Resolver
