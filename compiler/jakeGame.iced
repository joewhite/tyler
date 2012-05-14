fs = require 'fs'
glob = require 'glob'
path = require 'path'
Paths = require './paths'

root = path.resolve __dirname, '..'
paths = new Paths root, 'runtime', 'runtime/js', 'runtime/view'

directory 'www'
file 'www/index.html', ['www', 'game.json', paths.runtime.view 'index.chtml'], ->
    console.log 'www/index.html'
    eco = require 'eco'
    templatePath = paths.runtime.view 'index.chtml'
    template = fs.readFileSync templatePath, 'utf8'
    gameData = JSON.parse fs.readFileSync 'game.json', 'utf8'
    output = eco.render template, gameData
    fs.writeFileSync 'www/index.html', output

directory 'www/scripts'
scriptSourcePattern = paths.runtime.js('*.js')
# glob doesn't work with drive letters. Make sure to use relative path.
scriptSourcePattern = path.relative(process.cwd(), scriptSourcePattern)
# glob doesn't work with backslashes. Make sure to use forward slashes.
scriptSourcePattern = scriptSourcePattern.replace /[\\]/g, '/'
scriptSourcePaths = glob.sync scriptSourcePattern
scriptTargetPaths = []
for sourcePath in scriptSourcePaths
    targetPath = path.join 'www', 'scripts', path.basename sourcePath
    scriptTargetPaths.push targetPath
    do (sourcePath, targetPath) ->
        file targetPath, [sourcePath, 'www/scripts'], ->
            jake.cpR sourcePath, targetPath

task 'html', ['www/index.html']

task 'scripts', scriptTargetPaths

task 'default', ['html', 'scripts']