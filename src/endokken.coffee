#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

ClassPage = require './class-page'
Resolver = require './resolver'
Template = require './template'

object = JSON.parse(fs.readFileSync(path.join(__dirname, '../spec/fixtures/api.json')).toString())
Resolver.setMetadata(object)
klass = object.classes.TextEditor
document = Template.render('layout', content: ClassPage.render(klass), title: 'Endokken')

console.log(document)
