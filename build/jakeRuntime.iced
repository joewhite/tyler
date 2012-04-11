child_process = require 'child_process'
fs = require 'fs'
glob = require 'glob'
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

AMDEFINE_HEADER = '''
if (typeof define !== 'function') {
    var define = require('amdefine')(module);
}

'''

directory 'runtime/js'

runtimeDirectory = (runtimeDirectoryName) ->
    sourcePaths = glob.sync "runtime/#{runtimeDirectoryName}/**/*.iced"
    targetPaths = []
    headerRegex = ///
        ^                   # anchor to the beginning of the string
        [\r\n]*             # consume any leading blank lines
        (                   # begin the part we try to match and preserve
            /\*[^*]*?\*/    # match a multiline comment at the beginning of the file
            (\r?\n?){2}     # match up to two line breaks immediately following that comment
        )?                  # if there's no comment, just match ^ (beginning of string)
        [\r\n]*             # consume any additional blank lines after the comment
    ///
    for sourcePath in sourcePaths
        targetPath = path.join 'runtime', 'js', path.basename(sourcePath).replace '.iced', '.js'
        do (sourcePath, targetPath) ->
            file targetPath, [sourcePath, 'jakefile', 'build/jakeRuntime.iced', 'runtime/js'], ->
                iced = require 'iced-coffee-script'
                source = fs.readFileSync sourcePath, 'utf8'
                compiled = iced.compile source
                target = compiled.replace headerRegex, "$1#{AMDEFINE_HEADER}"
                fs.writeFileSync targetPath, target, 'utf8'
                complete()
            , async: true
        targetPaths.push targetPath
    desc "Builds the '#{runtimeDirectoryName}' runtime module"
    task runtimeDirectoryName, targetPaths

runtimeDirectory 'battle'

desc 'Builds all runtime libraries'
task 'runtime', ['battle']

task 'sample', ['runtime'], ->
    sh 'jake', cwd: 'sample', complete
, async: true

task 'test', ['runtime'], ->
    require 'iced-coffee-script'
    global.expect = require 'expect.js'
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