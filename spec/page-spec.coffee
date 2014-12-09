path = require 'path'

Page = require '../src/page'

helper = require './spec-helper'

describe 'Page', ->
  it 'accepts a path to a template when constructed', ->
    page = new Page(helper.getFixturePath('test.haml'))

    expect(page.templatePath).toEqual helper.getFixturePath('test.haml')

  it 'defaults the path to be based out of the templates directory', ->
    page = new Page('test.haml')

    expect(page.templatePath).toEqual path.join(path.dirname(__dirname), 'templates', 'test.haml')

  it 'accepts a path and an object when constructed', ->
    page = new Page helper.getFixturePath('test.haml'),
      foo: 'foo'
      bar: 'bar'
      baz: 'baz'

    expect(page.templatePath).toEqual helper.getFixturePath('test.haml')
    expect(page.locals).toEqual
      foo: 'foo'
      bar: 'bar'
      baz: 'baz'

  it 'renders the template using the locals', ->
    page = new Page helper.getFixturePath('test.haml'),
      foo: 'foo'
      bar: 'bar'
      baz: 'baz'

    expect(page.render()).toEqual """
    <p>foo</p>
    <p>bar</p>
    <p>baz</p>
    """

  it 'supports rendering functions too', ->
    page = new Page helper.getFixturePath('function.haml'),
      fn: -> 'test!'

    expect(page.render()).toEqual """
    <p>test!</p>
    """
