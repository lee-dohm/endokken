Resolver = require './resolver'
Template = require './template'

# Public: Renders a page for a class.
class ClassPage extends Template
  @render: (locals) ->
    new this(locals).render()

  constructor: (@object) ->
    locals = @object
    locals.classInfoSection = @classInfoSection()
    locals.descriptionSection = @descriptionSection()
    locals.sections = @sections()

    @title = @object.name

    super('class-page', locals)

  sections: ->
    (@section(section) for section in @object.sections).join('\n')

  section: (section) ->
    classProps = (prop for prop in @object.classProperties when prop.sectionName is section.name)
    section.classProperties = (@property(prop, type: 'static') for prop in classProps).join('\n')

    props = (prop for prop in @object.instanceProperties when prop.sectionName is section.name)
    section.properties = (@property(prop, type: 'instance') for prop in props).join('\n')

    classMethods = (method for method in @object.classMethods when method.sectionName is section.name)
    section.classMethods = (@method(method, type: 'static') for method in classMethods).join('\n')

    methods = (method for method in @object.instanceMethods when method.sectionName is section.name)
    section.methods = (@method(method, type: 'instance') for method in methods).join('\n')

    section.description = @markdownify(section.description)
    Template.render('section', section)

  method: (method, options) ->
    method.id = "#{options.type}-#{method.name}"
    method.type = options.type
    method.signature = "#{@signifier(options.type)}#{@signature(method)}"
    method.description = @resolveReferences(@markdownify(method.description))
    method.parameterBlock = if method.arguments then @parameterBlock(method) else ''
    method.returnValueBlock = if method.returnValues then @returnValueBlock(method) else ''
    Template.render('method', method)

  property: (property, options) ->
    property.id = "#{options.type}-#{property.name}"
    property.type = options.type
    property.signature = "#{@signifier(options.type)}#{property.name}"
    property.description = @resolveReferences(@markdownify(property.description))
    Template.render('property', property)

  signature: (method) ->
    parameters = if method.arguments then @parameters(method) else ''
    "#{method.name}(#{parameters})"

  signifier: (type) ->
    if type is 'static' then '.' else '::'

  classInfoSection: ->
    Template.render('class-info', @object)

  descriptionSection: ->
    if @object.description
      description = @resolveReferences(@markdownify(@object.description))
      Template.render('description-section', description: description)

  resolveReferences: (text) ->
    text.replace /\{\S*\}/g, (match) =>
      @resolveReference(match)

  resolveReference: (ref) ->
    result = Resolver.getInstance().resolve(ref)
    if typeof result is 'string'
      result
    else
      Template.render('reference', result)

  parameterBlock: (method) ->
    rows = (@parameterRow(parameter) for parameter in method.arguments)
    Template.render('parameter-block-table', rows: rows.join('\n'))

  parameterRow: (parameter) ->
    parameter.description = @markdownify(parameter.description, noParagraph: true)
    parameter.description = @resolveReferences(parameter.description)
    Template.render('parameter-block-row', parameter)

  returnValueBlock: (method) ->
    rows = (@returnValueRow(returnValue) for returnValue in method.returnValues)
    Template.render('return-value-block-table', rows: rows.join('\n'))

  returnValueRow: (returnValue) ->
    returnValue.description = @markdownify(returnValue.description, noParagraph: true)
    returnValue.description = @resolveReferences(returnValue.description)
    Template.render('return-value-block-row', returnValue)

  parameters: (method) ->
    names = (name for {name} in method.arguments)
    names.join(', ')

module.exports = ClassPage
