_ = require 'underscore-plus'

Template = require './template'

# Public: Renders a page for a class.
class ClassPage extends Template
  @render: (locals) ->
    new this().render(locals)

  constructor: () ->
    super('class-page')

  prepareLocals: (@object) ->
    console.log("Class: #{@object.name}")
    @object.classInfoSection = @classInfoSection()
    @object.descriptionSection = @descriptionSection()
    @object.examplesSection = @examplesSection(@object)
    @object.sections = @sections()

  render: (locals) ->
    @prepareLocals(locals)
    super(locals)

  examplesSection: (object) ->
    return '' unless object.examples

    console.log("  Examples")
    examples = (@example(example) for example in object.examples).join('\n')
    Template.render('examples', examples: examples)

  example: (example) ->
    example.raw = @markdownify(example.raw)
    Template.render('example', example)

  sections: ->
    sections = @object.sections
    sections.push({name: null})
    (@section(section) for section in sections).join('\n')

  section: (section) ->
    console.log("  Section: #{section.name}")

    section.classProperties = @processProperties(@object.classProperties, section.name, 'static')
    section.properties = @processProperties(@object.instanceProperties, section.name, 'instance')

    section.classMethods = @processMethods(@object.classMethods, section.name, 'static')
    section.methods = @processMethods(@object.instanceMethods, section.name, 'instance')

    section.description = @markdownify(@resolveReferences(section.description))

    if section.classProperties.length > 0 or section.properties.length > 0 or
       section.classMethods.length > 0 or section.methods.length > 0 or
       section.description.length > 0
      Template.render('section', section)

  processMethods: (methods, sectionName, type) ->
    methods = _.filter methods, (method) -> method.sectionName is sectionName
    methods = _.map methods, (method) => @method(method, type: type)
    methods.join('\n')

  processProperties: (properties, sectionName, type) ->
    props = _.filter properties, (prop) -> prop.sectionName is sectionName
    props = _.map props, (prop) => @property(prop, type: type)
    props.join('\n')

  method: (method, options) ->
    console.log("    Method: #{method.name}")

    method.id = "#{options.type}-#{method.name}"
    method.type = options.type
    method.signature = "#{@signifier(options.type)}#{@signature(method)}"
    method.description = @markdownify(@resolveReferences(method.description))
    method.examples = @examplesSection(method)
    method.parameterBlock = if method.arguments then @parameterBlock(method) else ''
    method.returnValueBlock = if method.returnValues then @returnValueBlock(method) else ''
    Template.render('method', method)

  property: (property, options) ->
    console.log("    Property: #{property.name}")

    property.id = "#{options.type}-#{property.name}"
    property.type = options.type
    property.signature = "#{@signifier(options.type)}#{property.name}"
    property.description = @markdownify(@resolveReferences(property.description))
    property.examples = @examplesSection(property)
    Template.render('property', property)

  signature: (method) ->
    parameters = if method.arguments then @parameters(method) else ''
    "#{method.name}(#{parameters})"

  signifier: (type) ->
    if type is 'static' then '.' else '::'

  classInfoSection: ->
    superClass = "{#{@object.superClass ? 'Object'}}"
    @object.superClass = @resolveReferences(superClass)
    Template.render('class-info', @object)

  descriptionSection: ->
    if @object.description
      description = @markdownify(@resolveReferences(@object.description))
      Template.render('description-section', description: description)

  parameterBlock: (method) ->
    rows = (@parameterRow(parameter) for parameter in method.arguments)
    Template.render('parameter-block-table', rows: rows.join('\n'))

  parameterRow: (parameter) ->
    parameter.description = @resolveReferences(parameter.description)
    parameter.description = @markdownify(parameter.description, noParagraph: true)
    Template.render('parameter-block-row', parameter)

  returnValueBlock: (method) ->
    rows = (@returnValueRow(returnValue) for returnValue in method.returnValues)
    Template.render('return-value-block-table', rows: rows.join('\n'))

  returnValueRow: (returnValue) ->
    returnValue.description = @resolveReferences(returnValue.description)
    returnValue.description = @markdownify(returnValue.description, noParagraph: true)
    Template.render('return-value-block-row', returnValue)

  parameters: (method) ->
    formatArgument = (argument) ->
      opt = if argument.isOptional then '<sup>?</sup>' else ''
      "#{argument.name}#{opt}"

    names = (formatArgument(argument) for argument in method.arguments)
    names.join(', ')

module.exports = ClassPage
