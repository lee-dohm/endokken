Template = require './template'

# Public: Renders a page for a class.
module.exports =
class ClassPage extends Template
  @render: (locals) ->
    new this(locals).render()

  constructor: (@object) ->
    locals = @object
    locals.classInfoSection = @classInfoSection()
    locals.classMethodDetailsSection = @classMethodDetailsSection()
    locals.classMethodSummarySection = @classMethodSummarySection()
    locals.descriptionSection = @descriptionSection()
    locals.instanceMethodDetailsSection = @instanceMethodDetailsSection()
    locals.instanceMethodSummarySection = @instanceMethodSummarySection()

    @title = @object.name

    super('class-page', locals)

  classInfoSection: ->
    Template.render('class-info', @object)

  classMethodDetailsSection: ->

  classMethodSummarySection: ->

  descriptionSection: ->
    if @object.description
      Template.render('description-section', description: @markdownify(@object.description))

  instanceMethodDetails: (method) ->
    method.signature = @signature(method)
    method.description = @markdownify(method.description)
    method.parameterBlock = if method.arguments then @parameterBlock(method) else ''
    method.returnValueBlock = if method.returnValues then @returnValueBlock(method) else ''
    Template.render('instance-method-details', method)

  instanceMethodDetailsSection: ->
    methods = (@instanceMethodDetails(method) for method in @object.instanceMethods)
    if methods?.length > 0
      Template.render('instance-method-detail-section', content: methods.join('\n'))

  instanceMethodSummary: (method) ->
    method.signature = @signature(method)
    method.summary = @markdownify(method.summary)
    Template.render('instance-method-summary', method)

  instanceMethodSummarySection: ->
    methods = (@instanceMethodSummary(method) for method in @object.instanceMethods)
    if methods?.length > 0
      Template.render('instance-method-summary-section', content: methods.join('\n'))

  signature: (method) ->
    parameters = if method.arguments then @parameters(method) else ''
    "#{method.name}(#{parameters})"

  parameterBlock: (method) ->
    rows = (@parameterRow(parameter) for parameter in method.arguments)
    Template.render('parameter-block-table', rows: rows.join('\n'))

  parameterRow: (parameter) ->
    parameter.description = @markdownify(parameter.description, noParagraph: true)
    Template.render('parameter-block-row', parameter)

  returnValueBlock: (method) ->
    rows = (@returnValueRow(returnValue) for returnValue in method.returnValues)
    Template.render('return-value-block-table', rows: rows.join('\n'))

  returnValueRow: (returnValue) ->
    returnValue.description = @markdownify(returnValue.description, noParagraph: true)
    Template.render('return-value-block-row', returnValue)

  parameters: (method) ->
    names = (name for {name} in method.arguments)
    names.join(', ')
