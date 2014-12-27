fs = require 'fs'

Resolver = require '../src/resolver'

helper = require './spec-helper'

mozillaBaseUrl = 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects'

describe 'Resolver', ->
  resolver = []

  beforeEach ->
    metadata = JSON.parse(fs.readFileSync(helper.getFixturePath('api.json')))
    resolver = new Resolver(metadata)

  it 'can be instantiated', ->
    expect(new Resolver).toBeDefined()

  describe 'text handling', ->
    it 'returns the original string if nothing is recognized', ->
      expect(resolver.resolve('foo')).toEqual 'foo'

    it 'includes the curly braces if nothing is recognized', ->
      expect(resolver.resolve('{Foo}')).toEqual '{Foo}'

    it 'returns an object if something is recognized', ->
      resolver.add('Foo', 'https://example.com/Foo')

      expect(resolver.resolve('Foo').name).toEqual 'Foo'
      expect(resolver.resolve('Foo').url).toEqual 'https://example.com/Foo'

    it 'disregards one set of curly braces', ->
      resolver.add('Foo', 'https://example.com/Foo')

      expect(resolver.resolve('{Foo}').name).toEqual 'Foo'
      expect(resolver.resolve('{Foo}').url).toEqual 'https://example.com/Foo'

    it 'disregards only one set of curly braces', ->
      resolver.add('Foo', 'https://example.com/Foo')

      expect(resolver.resolve('{{Foo}}')).toEqual '{{Foo}}'

  describe 'resolving external references', ->
    it 'resolves classes', ->
      expect(resolver.resolve('String').name).toEqual 'String'
      expect(resolver.resolve('String').url).toEqual "#{mozillaBaseUrl}/String"

    it 'resolves static items', ->
      expect(resolver.resolve('Date.UTC').name).toEqual 'Date.UTC'
      expect(resolver.resolve('Date.UTC').url).toEqual "#{mozillaBaseUrl}/Date/UTC"

    it 'resolves instance items', ->
      expect(resolver.resolve('Date::toJSON').name).toEqual 'Date::toJSON'
      expect(resolver.resolve('Date::toJSON').url).toEqual "#{mozillaBaseUrl}/Date/toJSON"

  describe 'resolving project references', ->
    it 'prefers project references to external references', ->
      resolver.add('Atom', 'https://example.com/Atom')

      expect(resolver.resolve('Atom').name).toEqual 'Atom'
      expect(resolver.resolve('Atom').url).toEqual 'class/Atom'

    it 'resolves classes', ->
      expect(resolver.resolve('Atom').name).toEqual 'Atom'
      expect(resolver.resolve('Atom').url).toEqual 'class/Atom'

    it 'resolves static items', ->
      expect(resolver.resolve('GitRepository.open').name).toEqual 'GitRepository.open'
      expect(resolver.resolve('GitRepository.open').url).toEqual 'GitRepository#static-open'

    it 'resolves instance items', ->
      expect(resolver.resolve('Atom::onDidBeep').name).toEqual 'Atom::onDidBeep'
      expect(resolver.resolve('Atom::onDidBeep').url).toEqual 'Atom#instance-onDidBeep'

    it 'resolves local static items', ->
      expect(resolver.resolve('.foo').name).toEqual '.foo'
      expect(resolver.resolve('.foo').url).toEqual '#static-foo'

    it 'resolves local static items', ->
      expect(resolver.resolve('{.foo}').name).toEqual '.foo'
      expect(resolver.resolve('{.foo}').url).toEqual '#static-foo'

    it 'resolves local instance items', ->
      expect(resolver.resolve('::foo').name).toEqual '::foo'
      expect(resolver.resolve('::foo').url).toEqual '#instance-foo'

    it 'resolves local instance items with curly braces', ->
      expect(resolver.resolve('{::foo}').name).toEqual '::foo'
      expect(resolver.resolve('{::foo}').url).toEqual '#instance-foo'
