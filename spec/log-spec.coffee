Log = require '../src/log'

describe 'Log', ->
  beforeEach ->
    spyOn(console, 'log')

  describe 'supports logging levels', ->
    it 'writes debug statements out to the console when the level is debug', ->
      Log.setLevel('debug')
      Log.d('test')

      expect(console.log).toHaveBeenCalledWith('test')

    it 'does not write debug statements when the level is other than debug', ->
      Log.setLevel('verbose')
      Log.d('test')

      expect(console.log).not.toHaveBeenCalled()

    it 'writes verbose statements when the level is verbose', ->
      Log.setLevel('verbose')
      Log.v('test')

      expect(console.log).toHaveBeenCalledWith('test')

    it 'writes verbose statements when the level is debug', ->
      Log.setLevel('debug')
      Log.v('test')

      expect(console.log).toHaveBeenCalledWith('test')

    it 'does not write verbose statements when the level is info', ->
      Log.setLevel('info')
      Log.v('test')

      expect(console.log).not.toHaveBeenCalled()

    it 'writes info statements when the level is info', ->
      Log.setLevel('info')
      Log.i('test')

      expect(console.log).toHaveBeenCalledWith('test')

    it 'writes info statements when the level is verbose', ->
      Log.setLevel('verbose')
      Log.i('test')

      expect(console.log).toHaveBeenCalledWith('test')

    it 'writes info statements when the level is debug', ->
      Log.setLevel('debug')
      Log.i('test')

      expect(console.log).toHaveBeenCalledWith('test')

    it 'does not write info statements when the level is warn', ->
      Log.setLevel('warn')
      Log.i('test')

      expect(console.log).not.toHaveBeenCalled()

  describe 'supports indentation', ->
    beforeEach ->
      Log.setLevel('debug')
      Log.setIndent(0)

    it 'can be indented arbitrarily', ->
      Log.setIndent(4)
      Log.d('test')

      expect(console.log).toHaveBeenCalledWith('    test')

    it 'can have its indentation increased', ->
      Log.increaseIndent()
      Log.d('test')

      expect(console.log).toHaveBeenCalledWith('  test')

    it 'can have its indentation decreased', ->
      Log.setIndent(4)
      Log.decreaseIndent()
      Log.d('test')

      expect(console.log).toHaveBeenCalledWith('  test')

    it 'does not allow its indentation to be set to less than zero', ->
      fn = ->
        Log.setIndent(-2)

      expect(fn).toThrow()

    it 'does not allow its indentation to be decreased below zero', ->
      Log.decreaseIndent()
      Log.d('test')

      expect(console.log).toHaveBeenCalledWith('test')

    it 'accepts a function on increase indent which is indented but not after', ->
      fn = ->
        Log.d('test')

      Log.increaseIndent(fn)
      expect(console.log).toHaveBeenCalledWith('  test')

      Log.d('test')
      expect(console.log).toHaveBeenCalledWith('test')

    it 'returns whatever the passed in function returns', ->
      fn = ->
        Log.d('test')
        5

      retval = Log.increaseIndent(fn)
      expect(retval).toBe 5
