define ['./knockout-2.1.0beta', './defend', './LICENSE'], (ko, Defend) ->
    class Troop
        constructor: ->
            @turnTimer = ko.observable 0
            @action = ko.observable new Defend
        timeslice: (done) ->
            timerValue = @turnTimer()
            if timerValue > 0
                @turnTimer timerValue - 1
                done()
            else
                @action().timeslice =>
                    @turnTimer @action().recoveryTime()
                    @action new Defend
                , done