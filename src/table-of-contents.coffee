Template = require './template'

class TableOfContents extends Template
  render: (contents) ->
    return '' unless contents?.length? and contents.length >= 2

    items = @renderContents(contents)
    Template.render('table-of-contents', items: items)

  renderContents: (contents) ->
    (@renderItem(item) for item in contents).join('\n')

  renderItem: (item) ->
    Template.render('toc-item', item)

module.exports = TableOfContents
