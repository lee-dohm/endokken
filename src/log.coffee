class LogError extends Error

# Public: Used to log messages to the console.
#
# ## Log Levels
#
# There are five valid logging levels. In order from lowest- to highest-priority they are:
# `debug`, `verbose`, `info`, `warn` and `error`. Setting the log level allows only messages
# of that priority or higher to be displayed.
#
# ## Indentation
#
# Indentation can be controlled to allow for display of nested state.
#
# ## Examples
#
# Log levels
#
# ```coffee
# Log.setLevel('warn')
# Log.w('This message will be displayed')
# Log.d('This message will not be displayed')
# ```
#
# Indentation
#
# ```coffee
# Log.d('Outer')                       # => Outer
# Log.increaseIndent -> Log.d('Inner') # =>   Inner
# Log.d('Outer again')                 # => Outer again
# ```
class Log
  constructor: ->
    @indent = 0

  ###
  Section: Logging
  ###

  # Public: Logs a `debug` message.
  #
  # * `message` Message {String} to log.
  d: (message) ->
    message = @indentText(message)
    console.log(message) if @levelNumber(@level) <= @levelNumber('debug')

  # Public: Logs a `verbose` message.
  #
  # * `message` Message {String} to log.
  v: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('verbose')

  # Public: Logs an `info` message.
  #
  # * `message` Message {String} to log.
  i: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('info')

  # Public: Logs a `warn` message.
  #
  # * `message` Message {String} to log.
  w: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('warn')

  # Public: Logs an `error` message.
  #
  # * `message` Message {String} to log.
  e: (message) ->
    console.log(message) if @levelNumber(@level) <= @levelNumber('error')

  ###
  Section: Indentation
  ###

  # Public: Decreases the indentation of all future log messages by one level.
  decreaseIndent: ->
    @indent -= 2
    @indent = 0 if @indent < 0

  # Public: Increases the indentation of all future log messages by one level.
  #
  # * `fn` (optional) {Function} to call synchronously within which indentation is increased by one
  #     level. Outside this function, indentation is unchanged.
  #
  # Returns whatever `fn` returns, if supplied.
  increaseIndent: (fn) ->
    @indent += 2

    if fn
      retval = fn()
      @indent -= 2
      retval

  # Public: Sets the indentation to the given width in spaces.
  #
  # * `level` {Number} of spaces to indent.
  setIndent: (indent) ->
    throw new LogError('Indentation cannot be less than zero') if indent < 0
    @indent = indent

  ###
  Section: Log Level
  ###

  # Public: Sets the logging level.
  #
  # * `level` Level name {String}.
  setLevel: (level) ->
    @level = level

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
