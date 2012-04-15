sinon = require 'sinon'
Action = require '../runtime/js/action'
Defend = require '../runtime/js/defend'
Troop = require '../runtime/js/troop'

subscribe = (observable) ->
    spy = sinon.spy()
    observable.subscribe spy
    spy

describe 'Troop timeslice', ->
    troop = null
    beforeEach ->
        troop = new Troop
    describe 'with time remaining on its turn timer', ->
        beforeEach ->
            troop.turnTimer 5
            troop.action new Action().timer 9
        describe 'when its timeslice starts', ->
            it 'ends its timeslice immediately', ->
                callback = sinon.spy()
                troop.timeslice callback
                expect(callback.calledOnce).to.be(true)
        describe 'when its timeslice ends', ->
            it 'has decremented its turn timer', (complete) ->
                initialTurnTimer = troop.turnTimer()
                troop.timeslice ->
                    expect(troop.turnTimer()).to.be(initialTurnTimer - 1)
                    complete()
            it 'has not changed its action timer', (complete) ->
                subscription = subscribe troop.action().timer
                troop.timeslice ->
                    expect(subscription.called).to.be(false)
                    complete()
            it 'has not performed its action', (complete) ->
                spy = sinon.spy troop.action(), 'perform'
                troop.timeslice ->
                    expect(spy.called).to.be(false)
                    complete()
            it 'has not changed its action', (complete) ->
                subscription = subscribe troop.action
                troop.timeslice ->
                    expect(subscription.called).to.be(false)
                    complete()
    describe 'with its turn timer finished', ->
        beforeEach ->
            troop.turnTimer 0
        describe 'and Defend selected', ->
            beforeEach ->
                troop.action new Defend
            describe 'when its timeslice starts', ->
                it 'ends its timeslice immediately', ->
                    callback = sinon.spy()
                    troop.timeslice callback
                    expect(callback.calledOnce).to.be(true)
            describe 'when its timeslice ends', ->
                it 'has not changed its turn timer', (complete) ->
                    subscription = subscribe troop.turnTimer
                    troop.timeslice ->
                        expect(subscription.called).to.be(false)
                        complete()
                it 'has not changed its action timer', (complete) ->
                    subscription = subscribe troop.action().timer
                    troop.timeslice ->
                        expect(subscription.called).to.be(false)
                        complete()
                it 'has not changed its action', (complete) ->
                    subscription = subscribe troop.action
                    troop.timeslice ->
                        expect(subscription.called).to.be(false)
                        complete()
        describe 'and an action selected', ->
            beforeEach ->
                action = new Action
                action.recoveryTime 99
                action.perform = ->
                    throw new Error 'Unexpected call to perform'
                troop.action action
            describe 'and time remaining on its action timer', ->
                beforeEach ->
                    troop.action().timer 7
                describe 'when its timeslice starts', ->
                    it 'ends its timeslice immediately', ->
                        callback = sinon.spy()
                        troop.timeslice callback
                        expect(callback.calledOnce).to.be(true)
                describe 'when its timeslice ends', ->
                    it 'has not changed its turn timer', (complete) ->
                        subscription = subscribe troop.turnTimer
                        troop.timeslice ->
                            expect(subscription.called).to.be(false)
                            complete()
                    it 'has decremented its action timer', (complete) ->
                        initialActionTimer = troop.action().timer()
                        troop.timeslice ->
                            expect(troop.action().timer()).to.be(initialActionTimer - 1)
                            complete()
                    it 'has not performed its action', (complete) ->
                        spy = sinon.spy troop.action(), 'perform'
                        troop.timeslice ->
                            expect(spy.called).to.be(false)
                            complete()
                    it 'has not changed its action', (complete) ->
                        subscription = subscribe troop.action
                        troop.timeslice ->
                            expect(subscription.called).to.be(false)
                            complete()
            describe 'and its action timer finished', ->
                performStub = null
                beforeEach ->
                    troop.action().timer 0
                    performStub = sinon.stub troop.action(), 'perform'
                describe 'when its timeslice starts', ->
                    it 'has begun executing its action', ->
                        troop.timeslice ->
                        expect(performStub.calledOnce).to.be(true)
                    it 'has not changed its turn timer', ->
                        subscription = subscribe troop.turnTimer
                        troop.timeslice ->
                        expect(subscription.called).to.be(false)
                    it 'has not changed its action timer', ->
                        subscription = subscribe troop.action().timer
                        troop.timeslice ->
                        expect(subscription.called).to.be(false)
                    it 'has not changed its action', ->
                        subscription = subscribe troop.action
                        troop.timeslice ->
                        expect(subscription.called).to.be(false)
                    it 'has not ended its timeslice', ->
                        callback = sinon.spy()
                        troop.timeslice callback
                        expect(callback.called).to.be(false)
                describe 'when its action completes', ->
                    it 'ends its timeslice immediately', ->
                        callback = sinon.spy()
                        troop.timeslice callback
                        performStub.yield()
                        expect(callback.calledOnce).to.be(true)
                describe 'when its timeslice ends', ->
                    it 'has reset its turn timer', (complete) ->
                        troop.action().recoveryTime 11
                        troop.timeslice ->
                            expect(troop.turnTimer()).to.be(11)
                            complete()
                        performStub.yield()
                    it 'has changed its action to Defend', (complete) ->
                        troop.timeslice ->
                            expect(troop.action()).to.be.a(Defend)
                            complete()
                        performStub.yield()