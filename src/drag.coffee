
a = angular.module 'builder.drag', []

a.provider '$drag', ->
    # ----------------------------------------
    # provider
    # ----------------------------------------
    $injector = null
    $rootScope = null


    # ----------------------------------------
    # properties
    # ----------------------------------------
    @data =
        # all draggable objects
        draggables: {}
        # all droppable objects
        droppables: {}


    # ----------------------------------------
    # event hooks
    # ----------------------------------------
    @mouseMoved = no
    @isMouseMoved = => @mouseMoved
    @hooks =
        down: {}
        move: {}
        up: {}
    @eventMouseMove = ->
    @eventMouseUp = ->
    $ =>
        $(document).on 'mousedown', (e) =>
            @mouseMoved = no
            func(e) for key, func of @hooks.down
            return
        $(document).on 'mousemove', (e) =>
            @mouseMoved = yes
            func(e) for key, func of @hooks.move
            return
        $(document).on 'mouseup', (e) =>
            func(e) for key, func of @hooks.up
            return


    # ----------------------------------------
    # private methods
    # ----------------------------------------
    @currentId = 0
    @getNewId = => "#{@currentId++}"


    @setupEasing = ->
        jQuery.extend jQuery.easing,
            easeOutQuad: (x, t, b, c, d) -> -c * (t /= d) * (t - 2) + b


    @setupProviders = (injector) ->
        ###
        Setup providers.
        ###
        $injector = injector
        $rootScope = $injector.get '$rootScope'


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


    delay = (ms, func) ->
        setTimeout ->
            func()
        , ms
    @autoScroll =
        up: no
        down: no
        scrolling: no
        scroll: =>
            @autoScroll.scrolling = yes
            if @autoScroll.up
                $('html, body').dequeue().animate
                    scrollTop: $(window).scrollTop() - 50
                , 100, 'easeOutQuad'
                delay 100, => @autoScroll.scroll()
            else if @autoScroll.down
                $('html, body').dequeue().animate
                    scrollTop: $(window).scrollTop() + 50
                , 100, 'easeOutQuad'
                delay 100, => @autoScroll.scroll()
            else
                @autoScroll.scrolling = no
        start: (e) =>
            if e.clientY < 50
                # up
                @autoScroll.up = yes
                @autoScroll.down = no
                @autoScroll.scroll() if not @autoScroll.scrolling
            else if e.clientY > $(window).innerHeight() - 50
                # down
                @autoScroll.up = no
                @autoScroll.down = yes
                @autoScroll.scroll() if not @autoScroll.scrolling
            else
                @autoScroll.up = no
                @autoScroll.down = no
        stop: =>
            @autoScroll.up = no
            @autoScroll.down = no


    @dragMirrorMode = ($element, defer=yes, object) =>
        result =
            id: @getNewId()
            mode: 'mirror'
            maternal: $element[0]
            element: null
            object: object

        $element.on 'mousedown', (e) =>
            e.preventDefault()

            $clone = $element.clone()
            result.element = $clone[0]
            $clone.addClass "fb-draggable form-horizontal prepare-dragging"
            @hooks.move.drag = (e, defer) =>
                if $clone.hasClass 'prepare-dragging'
                    $clone.css
                        width: $element.width()
                        height: $element.height()
                    $clone.removeClass 'prepare-dragging'
                    $clone.addClass 'dragging'
                    return if defer

                $clone.offset
                    left: e.pageX - $clone.width() / 2
                    top: e.pageY - $clone.height() / 2

                @autoScroll.start e

                # execute callback for droppables
                for id, droppable of @data.droppables
                    if @isHover $clone, $(droppable.element)
                        droppable.move e, result
                    else
                        droppable.out e, result
            @hooks.up.drag = (e) =>
                # execute callback for droppables
                for id, droppable of @data.droppables
                    isHover = @isHover $clone, $(droppable.element)
                    droppable.up e, isHover, result
                delete @hooks.move.drag
                delete @hooks.up.drag
                result.element = null
                $clone.remove()
                @autoScroll.stop()
            $('body').append $clone
            # setup left & top of the element
            @hooks.move.drag(e, defer) if not defer
        result


    @dragDragMode = ($element, defer=yes, object) =>
        result =
            id: @getNewId()
            mode: 'drag'
            maternal: null
            element: $element[0]
            object: object

        $element.addClass 'fb-draggable'
        $element.on 'mousedown', (e) =>
            e.preventDefault()
            return if $element.hasClass 'dragging'

            $element.addClass 'prepare-dragging'
            @hooks.move.drag = (e, defer) =>
                if $element.hasClass 'prepare-dragging'
                    $element.css
                        width: $element.width()
                        height: $element.height()
                    $element.removeClass 'prepare-dragging'
                    $element.addClass 'dragging'
                    return if defer

                $element.offset
                    left: e.pageX - $element.width() / 2
                    top: e.pageY - $element.height() / 2

                @autoScroll.start e

                # execute callback for droppables
                for id, droppable of @data.droppables
                    if @isHover $element, $(droppable.element)
                        droppable.move e, result
                    else
                        droppable.out e, result
                return
            @hooks.up.drag = (e) =>
                # execute callback for droppables
                for id, droppable of @data.droppables
                    isHover = @isHover $element, $(droppable.element)
                    droppable.up e, isHover, result

                delete @hooks.move.drag
                delete @hooks.up.drag
                $element.css
                    width: '', height: ''
                    left: '', top: ''
                $element.removeClass 'dragging defer-dragging'
                @autoScroll.stop()
            # setup left & top of the element
            @hooks.move.drag(e, defer) if not defer
        result


    @dropMode = ($element, options) =>
        result =
            id: @getNewId()
            element: $element[0]
            move: (e, draggable) ->
                $rootScope.$apply -> options.move?(e, draggable)
            up: (e, isHover, draggable) ->
                $rootScope.$apply -> options.up?(e, isHover, draggable)
            out: (e, draggable) ->
                $rootScope.$apply -> options.out?(e, draggable)
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
            defer: yes/no. defer dragging
            object: custom information
        ###
        result = []
        if options.mode is 'mirror'
            for element in $element
                draggable = @dragMirrorMode $(element), options.defer, options.object
                result.push draggable.id
                @data.draggables[draggable.id] = draggable
        else
            for element in $element
                draggable = @dragDragMode $(element), options.defer, options.object
                result.push draggable.id
                @data.draggables[draggable.id] = draggable
        result


    @droppable = ($element, options={}) =>
        ###
        Make the element coulde be drop.
        @param $element: The jQuery element.
        @param options: The droppable options.
            move: The custom mouse move callback. (e, draggable)->
            up: The custom mouse up callback. (e, isHover, draggable)->
            out: The custom mouse out callback. (e, draggable)->
        ###
        result = []
        for element in $element
            droppable = @dropMode $(element), options
            result.push droppable
            @data.droppables[droppable.id] = droppable
        result


    # ----------------------------------------
    # $get
    # ----------------------------------------
    @get = ($injector) ->
        @setupEasing()
        @setupProviders $injector

        isMouseMoved: @isMouseMoved
        data: @data
        draggable: @draggable
        droppable: @droppable
    @get.$inject = ['$injector']
    @$get = @get
    return
