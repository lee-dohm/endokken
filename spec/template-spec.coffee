path = require 'path'

hamlc = require 'haml-coffee'

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
    describe 'when given a simple file name', ->
      it 'adds the template directory', ->
        expectedPath = path.join(path.dirname(__dirname), 'templates/file.haml')

        expect(template.normalizeTemplatePath('file.haml')).toEqual expectedPath

      it 'adds the haml extension', ->
        expectedPath = path.join(path.dirname(__dirname), 'templates/file.haml')

        expect(template.normalizeTemplatePath('file')).toEqual expectedPath

    describe 'when given a path', ->
      it 'does not add the template directory', ->
        expect(template.normalizeTemplatePath('temp/file.haml')).toEqual 'temp/file.haml'

      it 'adds the haml extension', ->
        expect(template.normalizeTemplatePath('temp/file')).toEqual 'temp/file.haml'

  describe 'rendering a template', ->
    it 'renders a simple template with no local variables', ->
      expect(template.render()).toEqual """
      <h1>Test</h1>
      <p>Testy, test, test ...</p>
      """

    it 'renders a template with locals', ->
      template = new Template(helper.getFixturePath('locals.haml'))

      expect(template.render(test: 'foo')).toEqual '<p>foo</p>'

  # describe 'updating fields according to spec', ->
  #   beforeEach ->
  #     template = new Template(helper.getFixturePath('locals.haml'))
  #
  #   it 'resolves references', ->
  #     expect(template.render(test: '{String}', resolve: ['test'])).toEqual '<a href="">String</a>'
