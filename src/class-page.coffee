_ = require 'underscore-plus'

Template = require './template'

# Public: Renders a page for a class.
class ClassPage extends Template
  @render: (locals) ->
    new this(locals).render()

  constructor: (@object) ->
    console.log("Class: #{@object.name}")
    locals = @object
    locals.classInfoSection = @classInfoSection()
    locals.descriptionSection = @descriptionSection()
    locals.sections = @sections()

    @title = @object.name

    super('class-page', locals)

  sections: ->
    sections = @object.sections
    sections.push({name: null})
    (@section(section) for section in sections).join('\n')

  section: (section) ->
    console.log("  Section: #{section.name}")

    props = _.filter @object.classProperties, (prop) -> prop.sectionName is section.name
    props = _.map props, (prop) => @property(prop, type: 'static')
    section.classProperties = props.join('\n')

    props = _.filter @object.instanceProperties, (prop) -> prop.sectionName is section.name
    props = _.map props, (prop) => @property(prop, type: 'instance')
    section.properties = props.join('\n')

    methods = _.filter @object.classMethods, (method) -> method.sectionName is section.name
    methods = _.map methods, (method) => @method(method, type: 'static')
    section.classMethods = methods.join('\n')

    methods = _.filter @object.instanceMethods, (method) -> method.sectionName is section.name
    methods = _.map methods, (method) => @method(method, type: 'instance')
    section.methods = methods.join('\n')

    section.description = @markdownify(@resolveReferences(section.description))

    if section.classProperties.length > 0 or section.properties.length > 0 or
       section.classMethods.length > 0 or section.methods.length > 0 or
       section.description.length > 0
      Template.render('section', section)

  method: (method, options) ->
    console.log("    Method: #{method.name}")

    method.id = "#{options.type}-#{method.name}"
    method.type = options.type
    method.signature = "#{@signifier(options.type)}#{@signature(method)}"
    method.description = @markdownify(@resolveReferences(method.description))
    method.parameterBlock = if method.arguments then @parameterBlock(method) else ''
    method.returnValueBlock = if method.returnValues then @returnValueBlock(method) else ''
    Template.render('method', method)

  property: (property, options) ->
    console.log("    Property: #{property.name}")

    property.id = "#{options.type}-#{property.name}"
    property.type = options.type
    property.signature = "#{@signifier(options.type)}#{property.name}"
    property.description = @markdownify(@resolveReferences(property.description))
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
    names = (name for {name} in method.arguments)
    names.join(', ')

module.exports = ClassPage
