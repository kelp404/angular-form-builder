
a = angular.module 'builder.drag', []

a.provider '$drag', ->
    # ----------------------------------------
    # provider
    # ----------------------------------------
    $injector = null


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
    @hooks =
        move: {}
        up: {}
    @eventMouseMove = ->
    @eventMouseUp = ->
    $ =>
        $(document).on 'mousemove', (e) =>
            func?(e) for key, func of @hooks.move
            return
        $(document).on 'mouseup', (e) =>
            func?(e) for key, func of @hooks.up
            return


    # ----------------------------------------
    # private methods
    # ----------------------------------------
    @currentId = 0
    @getNewId = =>
        return "#{@currentId++}"


    @setupProviders = (injector) ->
        ###
        Setup providers.
        ###
        $injector = injector


    @isHover = ($elementA, $elementB) =>
        ###
        Is element A hover on element B?
        @param $elementA: jQuery object
        @param $elementB: jQuery object
        ###
        offsetA = $elementA.offset()
        offsetB = $elementB.offset()
        sizeA =
            width: $elementA.width()
            height: $elementA.height()
        sizeB =
            width: $elementB.width()
            height: $elementB.height()
        isHover =
            x: no
            y: no
        # x
        isHover.x = offsetA.left > offsetB.left and offsetA.left < offsetB.left + sizeB.width
        isHover.x = isHover.x or offsetA.left + sizeA.width > offsetB.left and offsetA.left + sizeA.width < offsetB.left + sizeB.width
        return no if not isHover
        # y
        isHover.y = offsetA.top > offsetB.top and offsetA.top < offsetB.top + sizeB.height
        isHover.y = isHover.y or offsetA.top + sizeA.height > offsetB.top and offsetA.top + sizeA.height < offsetB.top + sizeB.height
        isHover.x and isHover.y


    @dragMirrorMode = ($element) =>
        result =
            id: @getNewId()
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
            @hooks.move.drag = (e) =>
                offset =
                    left: e.pageX - $clone.width() / 2
                    top: e.pageY - $clone.height() / 2
                $clone.offset offset

                # execute callback for droppables
                for droppable in @data.droppables
                    if @isHover $clone, $(droppable.element)
                        droppable.move e, result
                    else
                        droppable.out e, result
            @hooks.up.drag = (e) =>
                # execute callback for droppables
                for droppable in @data.droppables when @isHover $clone, $(droppable.element)
                    droppable.up e, result
                delete @hooks.move.drag
                delete @hooks.up.drag
                result.element = null
                $clone.remove()
            $('body').append $clone
            @hooks.move.drag e   # setup left & top of the element
        result


    @dragDragMode = ($element) =>
        result =
            id: @getNewId()
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
            @hooks.move.drag = (e) =>
                offset =
                    left: e.pageX - $element.width() / 2
                    top: e.pageY - $element.height() / 2
                $element.offset offset

                # execute callback for droppables
                for droppable in @data.droppables
                    if @isHover $element, $(droppable.element)
                        droppable.move e, result
                    else
                        droppable.out e, result
            @hooks.up.drag = (e) =>
                # execute callback for droppables
                for droppable in @data.droppables when @isHover $element, $(droppable.element)
                    droppable.up e, result

                delete @hooks.move.drag
                delete @hooks.up.drag
                $element.css
                    width: ''
                    height: ''
                    left: ''
                    top: ''
                $element.removeClass 'dragging'
            @hooks.move.drag e   # setup left & top of the element
        result


    @dropCustomMode = ($element, options) =>
        result =
            id: @getNewId()
            mode: 'custom'
            element: $element[0]
            move: options.move
            up: options.up
            out: options.out
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
                @data.draggables.push @dragMirrorMode($(element))
        else
            for element in $element
                @data.draggables.push @dragDragMode($(element))
        return


    @droppable = ($element, options={}) =>
        ###
        Make the element coulde be drop.
        @param $element: The jQuery element.
        @param options: The droppable options.
            mode: 'default' [default], 'custom'
            move: The custom mouse move callback. (e, draggable)->
            up: The custom mouse up callback. (e, draggable)->
            out: The custom mouse out callback. (e, draggable)->
        ###
        if options.mode is 'custom'
            for element in $element
                @data.droppables.push @dropCustomMode($(element), options)
        return


    # ----------------------------------------
    # $get
    # ----------------------------------------
    @get = ($injector) ->
        @setupProviders $injector

        data: @data
        draggable: @draggable
        droppable: @droppable
    @get.inject = ['$injector']
    @$get = @get
    return
