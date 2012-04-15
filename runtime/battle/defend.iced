define ['./action'], (Action) ->
    class Defend extends Action
        timeslice: (resetAction, done) ->
            done()