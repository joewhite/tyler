define ['./knockout-2.1.0beta'], (ko) ->
    class Troop
        constructor: ->
            @name = ko.observable()