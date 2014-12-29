fs = require 'fs'
path = require 'path'

donna = require 'donna'
tello = require 'tello'

ClassPage = require './class-page'
FilePage = require './file-page'
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
    packagePath = path.join(path.dirname(__dirname), 'package.json')
    packageInfo = JSON.parse(fs.readFileSync(packagePath).toString())
    @version = packageInfo.version
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
    @getNavItems(@digestedMetadata)
    @renderClass(klass) for _, klass of @digestedMetadata.classes
    @renderFile(file) for file in @docFiles()

  docFiles: ->
    (file for file in fs.readdirSync('.') when file.match(/\.md$/))

  getNavClasses: (metadata) ->
    navItems = (name for name, _ of metadata.classes)
    items = (Template.render('nav-item', name: item, url: item) for item in navItems).join('\n')
    Template.render('navigation', title: 'Classes', items: items)

  getNavFiles: (pathName) ->
    files = (path.basename(file, path.extname(file)) for file in @docFiles())
    items = (Template.render('nav-item', name: file, url: file) for file in files).join('\n')
    Template.render('navigation', title: 'Files', items: items)

  getNavItems: (metadata) ->
    classes = @getNavClasses(metadata)
    files = @getNavFiles('.')
    @navigation = "#{classes}\n#{files}"

  render: (content, filePath) ->
    doc = Template.render 'layout',
                          content: content
                          title: 'Endokken'
                          navigation: @navigation
                          version: @version
    fs.writeFileSync(filePath, doc)

  renderFile: (file) ->
    @render(FilePage.render(file), "./docs/#{path.basename(file, path.extname(file))}")

  renderClass: (klass) ->
    @render(ClassPage.render(klass), "./docs/#{klass.name}")

module.exports = Cli
