fs = require 'fs'
path = require 'path'

root = (pathFragments...) -> path.join __dirname, '..', pathFragments...
runtime = (pathFragments...) -> root 'runtime', pathFragments...
runtime.views = (pathFragments...) -> runtime 'views', pathFragments...

directory 'www'
file 'www/index.html', ['www', runtime.views 'index.chtml'], ->
    console.log 'www/index.html'
    eco = require 'eco'
    templatePath = runtime.views 'index.chtml'
    template = fs.readFileSync templatePath, 'utf8'
    gameData = JSON.parse fs.readFileSync 'game.json', 'utf8'
    output = eco.render template, gameData
    fs.writeFileSync 'www/index.html', output

task 'default', ['www/index.html']