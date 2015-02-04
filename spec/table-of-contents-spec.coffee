TableOfContents = require '../src/table-of-contents'

{getFixtureText} = require './spec-helper'

describe 'TableOfContents', ->
  it 'renders nothing when empty', ->
    toc = new TableOfContents

    expect(toc.render()).toEqual ''

  it 'renders nothing when not supplied an array', ->
    toc = new TableOfContents

    expect(toc.render(1)).toEqual ''

  it 'renders nothing when there are no sub-headings and only one item', ->
    toc = new TableOfContents

    expect(toc.render([{name: 'foo', url: 'bar'}])).toEqual ''

  it 'renders multiple items', ->
    toc = new TableOfContents
    contents = [
      {name: 'foo', url: 'foo'}
      {name: 'bar', url: 'bar'}
    ]

    expect(toc.render(contents)).toEqual getFixtureText('two-items.html')
