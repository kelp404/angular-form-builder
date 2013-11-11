
a = angular.module 'builder.drag', []

drag = ($injector) ->
    # ----------------------------------------
    # provider
    # ----------------------------------------


    # ----------------------------------------
    # properties
    # ----------------------------------------
    @data =
        # all draggable objects
        draggables: []
        # all droppable objects
        droppables: []


    # ----------------------------------------
    # event hooks
    # ----------------------------------------
    @eventMouseDown = ->
    @eventMouseMove = ->
    @eventMouseUp = ->
    $ =>
        $(document).on 'mousedown', (e) => @eventMouseDown e
        $(document).on 'mousemove', (e) => @eventMouseMove e
        $(document).on 'mouseup', (e) => @eventMouseUp e


    # ----------------------------------------
    # private methods
    # ----------------------------------------
    @makeMirrorMode = ($element) =>
        result =
            mode: 'mirror'
            maternal: $element[0]
            element: null

        $element.on 'mousedown', (e) =>
            e.preventDefault()

            $clone = $element.clone()
            result.element = $clone[0]
            $clone.css
                width: $element.width()
                height: $element.height()
            $clone.addClass "fb-draggable form-horizontal dragging"
            @eventMouseMove = (e) =>
                $clone.offset
                    left: e.pageX - $clone.width() / 2
                    top: e.pageY - $clone.height() / 2
            @eventMouseUp = (e) =>
                @eventMouseMove = ->
                @eventMouseUp = ->
                result.element = null
                $clone.remove()
            $('body').append $clone
            @eventMouseMove e   # setup left & top of the element
        result


    @makeDragMode = ($element) =>
        result =
            mode: 'drag'
            maternal: null
            element: $element[0]

        $element.addClass 'fb-draggable'
        $element.on 'mousedown', (e) =>
            e.preventDefault()
            return if $element.hasClass 'dragging'

            $element.css
                width: $element.width()
                height: $element.height()
            $element.addClass 'dragging'
            @eventMouseMove = (e) =>
                $element.offset
                    left: e.pageX - $element.width() / 2
                    top: e.pageY - $element.height() / 2
            @eventMouseUp = (e) =>
                @eventMouseMove = ->
                @eventMouseUp = ->
                $element.css
                    width: ''
                    height: ''
                    left: ''
                    top: ''
                $element.removeClass 'dragging'
            @eventMouseMove e   # setup left & top of the element
        result


    # ----------------------------------------
    # public methods
    # ----------------------------------------
    @draggable = ($element, options={}) =>
        ###
        Make the element could be drag.
        @param element: The jQuery element.
        @param options: Options
            mode: 'drag' [default], 'mirror'
        ###
        if options.mode is 'mirror'
            for element in $element
                @data.draggables.push @makeMirrorMode($(element))
        else
            for element in $element
                @data.draggables.push @makeDragMode($(element))
        return


    @removeDraggable = ($element) ->
        $element


    @droppable = ($element, opeions) ->
        ###
        Make the element coulde be drop.
        @param $element: The jQuery element.
        ###
        $element


    # ----------------------------------------
    # factory
    # ----------------------------------------
    data: @data
    draggable: @draggable
    removeDraggable: @removeDraggable
    droppable: @droppable

drag.$inject = ['$injector']
a.factory '$drag', drag
