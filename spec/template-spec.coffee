path = require 'path'

Template = require '../src/template'

helper = require './spec-helper'

describe 'Template', ->
  [template] = []

  beforeEach ->
    template = new Template(helper.getFixturePath('test.haml'))

  describe '::markdownify', ->
    it 'converts the supplied text from Markdown to HTML', ->
      expect(template.markdownify('Test')).toEqual '<p>Test</p>\n'

    it 'strips paragraph tags', ->
      expect(template.markdownify('Test', noParagraph: true)).toEqual 'Test\n'

  describe '::normalizeTemplatePath', ->
    it 'adds the template directory', ->
      expectedPath = path.join(path.dirname(__dirname), 'templates/file.haml')

      expect(template.normalizeTemplatePath('file.haml')).toEqual expectedPath

    it 'adds the haml extension', ->
      expectedPath = path.join(path.dirname(__dirname), 'templates/file.haml')

      expect(template.normalizeTemplatePath('file')).toEqual expectedPath
