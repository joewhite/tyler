define ['./action', './LICENSE'], (Action) ->
    class Defend extends Action
        timeslice: (resetAction, done) ->
            done()