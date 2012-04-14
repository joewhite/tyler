require '../runtime/js/action'
describe 'Smoke test', ->
    it 'works', ->
        expect(1).to.be(1)
    it 'is observable', ->
        Troop = require '../runtime/js/troop.js'
        troop = new Troop
        troop.name('Bob')
        expect(troop.name()).to.be('Bob')