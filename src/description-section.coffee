marked = require 'marked'

Page = require './page'

module.exports =
class DescriptionSection
  constructor: (@description) ->

  render: ->
    new Page('description-section.haml', description: marked(@description)).render() if @description
