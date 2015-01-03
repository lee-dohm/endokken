class LogError extends Error

# Public: Used to log events.
class Log
  constructor: ->
    @indent = 0

  decreaseIndent: ->
    @indent -= 2
    @indent = 0 if @indent < 0

  increaseIndent: (callback) ->
    @indent += 2

    if callback
      retval = callback()
      @indent -= 2
      retval

  setIndent: (indent) ->
    throw new LogError('Indentation cannot be less than zero') if indent < 0
    @indent = indent

  setLevel: (level) ->
    @level = level

  d: (message) ->
    message = @indentText(message)
    console.log(message) if @levelNumber(@level) <= @levelNumber('debug')

  v: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('verbose')

  i: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('info')

  w: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('warn')

  e: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('error')

  levelNumber: (level) ->
    switch level
      when 'debug' then 0
      when 'verbose' then 1
      when 'info' then 2
      when 'warn' then 3
      when 'error' then 4
      else 0

  indentText: (message) ->
    indentation = Array(@indent + 1).join(' ')
    indentation + message

module.exports = new Log
