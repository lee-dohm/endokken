DescriptionSection = require './description-section'
Page = require './page'

# Public: Renders a page for a class.
module.exports =
class ClassPage extends Page
  constructor: (@object) ->
    @locals =
      title: "Endokken: #{@object.name}"
      name: @object.name

    @locals.descriptionSection = new DescriptionSection(@object.description).render()
    @templatePath = @normalizeTemplatePath('class-page.haml')
