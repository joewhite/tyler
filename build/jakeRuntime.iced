child_process = require 'child_process'
path = require 'path'

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

task 'test', ->
    require 'iced-coffee-script'
    global.expect = require 'expect.js'
    glob = require 'glob'
    Mocha = require 'mocha'
    mocha = new Mocha reporter: 'spec'
    glob '**/test/**/*.iced', (err, files) ->
        throw err if err?
        for file in files
            mocha.addFile file
        mocha.run (failures) ->
            throw new Error "Tests failed" if failures != 0
            complete()
, async: true

task 'default', ['test', 'sample']