Cli = require '../src/cli'

describe 'Cli', ->
  [cli] = []

  beforeEach ->
    cli = new Cli()

  describe 'arguments', ->
    describe '--extension', ->
      it 'stores the extension', ->
        cli.parseArguments(['--extension', 'html'])

        expect(cli.args.extension).toEqual('html')

      it 'handles the short form', ->
        cli.parseArguments(['-e', 'html'])

        expect(cli.args.extension).toEqual('html')

      it 'defaults to the empty String', ->
        cli.parseArguments([])

        expect(cli.args.extension).toEqual('')

    describe '--metadata', ->
      it 'defaults to false', ->
        cli.parseArguments([])

        expect(cli.args.metadata).toEqual(false)

      it 'is true when the option is given without a file name', ->
        cli.parseArguments(['--metadata'])

        expect(cli.args.metadata).toEqual(true)

      it 'is equal to the file name when given', ->
        cli.parseArguments(['--metadata', 'api.json'])

        expect(cli.args.metadata).toEqual('api.json')