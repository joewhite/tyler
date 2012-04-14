fs = require 'fs'
path = require 'path'
Paths = require './paths'

root = path.resolve __dirname, '..'
paths = new Paths root, 'runtime', 'runtime/view'

directory 'www'
file 'www/index.html', ['www', 'game.json', paths.runtime.view 'index.chtml'], ->
    console.log 'www/index.html'
    eco = require 'eco'
    templatePath = paths.runtime.view 'index.chtml'
    template = fs.readFileSync templatePath, 'utf8'
    gameData = JSON.parse fs.readFileSync 'game.json', 'utf8'
    output = eco.render template, gameData
    fs.writeFileSync 'www/index.html', output

task 'default', ['www/index.html']