fs = require 'fs'
path = require 'path'

donna = require 'donna'
tello = require 'tello'

ClassPage = require './class-page'
Resolver = require './resolver'
Template = require './template'

# Public: Used to provide the command-line interface for the tool.
#
# ## Examples
#
# ```coffee
# cli = new Cli
# cli.run()
# ```
class Cli
  constructor: ->
    @parseArguments()

  run: ->
    @generateMetadata()
    @generateDocumentation()

  buildDocsDirectory: ->
    fs.mkdirSync('./docs') unless fs.existsSync('./docs')

    staticPath = path.join(__dirname, '../static')
    for source in fs.readdirSync(staticPath)
      @copyFile(path.join(staticPath, source.toString()), './docs')

  copyFile: (source, dir) ->
    destination = path.join(dir, path.basename(source))
    fs.writeFileSync(destination, fs.readFileSync(source))

  generateDocumentation: ->
    @buildDocsDirectory()

    Resolver.setMetadata(@metadata)
    @renderClass(klass) for _, klass of @metadata.classes

  generateMetadata: ->
    rootPath = path.resolve('.')

    @metadata = tello.digest(donna.generateMetadata([rootPath]))

  parseArguments: ->
    @args = require('yargs').argv

  renderClass: (klass) ->
    doc = Template.render('layout', content: ClassPage.render(klass), title: 'Endokken')
    fs.writeFileSync("./docs/#{klass.name}.html", doc)

module.exports = Cli
