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
  # Public: Parses the command-line arguments.
  constructor: ->
    @parseArguments()

  # Public: Executes the program.
  run: ->
    @generateMetadata()
    @generateDocumentation()

  parseArguments: ->
    @args = require('yargs')
    @args = @args.options 'metadata',
              alias: 'm'
              default: false
              describe: 'Dump metadata to a file or api.json if no filename given'
    @args = @args.help('help').alias('help', '?')
    @args = @args.argv

  ###
  Section: Metadata
  ###

  generateMetadata: ->
    rootPath = path.resolve('.')

    @metadata = donna.generateMetadata([rootPath])
    @digestedMetadata = tello.digest(@metadata)
    @dumpMetadata() if @args.metadata

  dumpMetadata: ->
    switch @args.metadata
      when true then @writeMetadata('api.json', @digestedMetadata)
      else @writeMetadata(@args.metadata, @digestedMetadata)

  writeMetadata: (fileName, metadata) ->
    text = JSON.stringify(metadata, null, 2)
    fs.writeFileSync(fileName, text)

  ###
  Section: Documentation
  ###

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

    Resolver.setMetadata(@digestedMetadata)
    @renderClass(klass) for _, klass of @digestedMetadata.classes

  renderClass: (klass) ->
    doc = Template.render('layout', content: ClassPage.render(klass), title: 'Endokken')
    fs.writeFileSync("./docs/#{klass.name}", doc)

module.exports = Cli
