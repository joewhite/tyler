define ['./knockout-2.1.0', './LICENSE'], (ko) ->
    class Action
        constructor: ->
            @timer = ko.observable 0
            @recoveryTime = ko.observable 0
        perform: ->
        timeslice: (resetAction, done) ->
            timerValue = @timer()
            if timerValue > 0
                @timer timerValue - 1
                done()
            else
                @perform ->
                    resetAction()
                    done()