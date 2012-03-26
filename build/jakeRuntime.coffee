child_process = require 'child_process'

sh = (commandLine, options, callback) ->
    if typeof options == 'function'
        callback = options
        options = undefined
    shell = '/bin/sh'
    args = ['-c', commandLine]
    if process.platform == 'win32'
        shell = 'cmd'
        args = ['/c', commandLine]
    child = child_process.spawn shell, args, options
    child.stdout.pipe process.stdout
    child.stderr.pipe process.stderr
    child.on 'exit', (code, signal) ->
        throw new Error "Process terminated with signal #{signal}" if signal?
        throw new Error "Process exited with error code #{code}" if code != 0
        callback()

task 'sample', ->
    sh 'jake', cwd: 'sample', complete
, async: true

task 'default', ['sample']
