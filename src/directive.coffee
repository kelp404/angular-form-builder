
class Draggable
    constructor: ($injector, object) ->
        @injector = $injector
        @$maternal = null
        @$element = null

        if object.maternal
            # mirror mode
            @$maternal = $(object.maternal)
            @mirrorMode(@$maternal)
        else if object.element
            @$element = $(object.element)
            @dragMode(@$element)

    mirrorMode: ($maternal) =>
        $maternal.bind 'mousedown', (e) =>
            e.preventDefault()
            @$element = $maternal.clone()
            @$element.addClass 'fb-draggable form-horizontal'
            $('body').append @$element
            callback =
                move: (e) =>
                    @$element.offset
                        left: e.pageX - @$element.width() / 2
                        top: e.pageY - @$element.height() / 2
                up: (e) => @$element.remove()
            @beginDrag @$element, callback,
                width: @$maternal.width()
                height: @$maternal.height()
                left: e.pageX - @$maternal.width() / 2
                top: e.pageY - @$maternal.height() / 2

    dragMode: ($element) =>
        $element.addClass 'fb-draggable'
        $element.bind 'mousedown', (e) =>
            e.preventDefault()
            return if $element.hasClass 'dragging'
            callback =
                move: (e) =>
                    return if not $element.hasClass 'dragging'
                    $element.offset
                        left: e.pageX - $element.width() / 2
                        top: e.pageY - $element.height() / 2
                up: (e) =>
                    return if not $element.hasClass 'dragging'
                    $element.css
                        width: ''
                        height: ''
                        left: ''
                        top: ''
                    $element.removeClass 'dragging'
            @beginDrag $element, callback,
                width: $element.width()
                height: $element.height()

    beginDrag: (element, callback, object) =>
        element.addClass 'dragging'
        element.css
            width: object.width
            height: object.height
            left: object?.left
            top: object?.top
        $(document).on 'mousemove', element, (e) -> callback.move(e) if callback.move
        element.bind 'mouseup', (e) ->
            $(document).off 'mousemove', element
            callback.up(e) if callback.up


# ----------------------------------------
# builder.directive
# ----------------------------------------
a = angular.module 'builder.directive', ['builder.provider', 'builder.controller']

# ----------------------------------------
# fb-builder, fb-droppable
# ----------------------------------------
fbBuilder = ($injector) ->
    restrict: 'A'
    template:
        """
        <div class='form-horizontal'>
            <div class='fb-component'
                ng-repeat="object in form"
                fb-form-object="object" fb-draggable></div>
        </div>
        """
    controller: 'fbBuilderController'
    link: (scope, element, attrs) ->
        # ----------------------------------------
        # providers
        # ----------------------------------------
        $builder = $injector.get '$builder'

        # ----------------------------------------
        # valuables
        # ----------------------------------------
        scope.formName = attrs.fbBuilder
        $builder.forms[scope.formName] ?= []
        scope.form = $builder.forms[scope.formName]

        $(element).addClass 'fb-builder fb-droppable'

fbBuilder.$inject = ['$injector']
a.directive 'fbBuilder', fbBuilder


# ----------------------------------------
# fb-components
# ----------------------------------------
fbComponents = ($injector) ->
    restrict: 'A'
    template:
        """
        <ul ng-if="groups.length > 1" class="nav nav-tabs nav-justified">
            <li ng-repeat="group in groups" ng-class="{active:status.activeGroup==group}">
                <a href='#' ng-click="action.selectGroup($event, group)">{{group}}</a>
            </li>
        </ul>
        <div class='form-horizontal'>
            <div class='fb-component'
                ng-repeat="component in components|filter:{group:status.activeGroup}"
                fb-component="component" fb-draggable-maternal></div>
        </div>
        """
    controller: 'fbComponentsController'

fbComponents.$inject = ['$injector']
a.directive 'fbComponents', fbComponents

# ----------------------------------------
# fb-component, fb-form-object
# ----------------------------------------
fbComponent = ($injector) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        # providers
        $builder = $injector.get '$builder'
        $parse = $injector.get '$parse'
        $compile = $injector.get '$compile'

        # valuables
        cs = scope.$new()   # component scope
        if attrs.fbComponent
            component = $parse(attrs.fbComponent) scope
            $.extend cs, component
        else
            formObject = $parse(attrs.fbFormObject) scope
            component = $builder.components[formObject.component]
            $.extend cs, formObject

        $template = $(component.template)
        view = $compile($template) cs
        $(element).append view
fbComponent.$inject = ['$injector']
a.directive 'fbComponent', fbComponent
a.directive 'fbFormObject', fbComponent


# ----------------------------------------
# fb-draggable-maternal
# ----------------------------------------
fbDraggableMaternal = ($injector) ->
    restrict: 'A'
    link: (scope, element) ->
        new Draggable $injector,
            maternal: element

fbDraggableMaternal.$inject = ['$injector']
a.directive 'fbDraggableMaternal', fbDraggableMaternal

# ----------------------------------------
# fb-draggable
# ----------------------------------------
fbDraggable = ($injector) ->
    restrict: 'A'
    link: (scope, element) ->
        new Draggable $injector,
            element: element

fbDraggableMaternal.$inject = ['$injector']
a.directive 'fbDraggable', fbDraggable


# ----------------------------------------
# fb-form
# ----------------------------------------
fbForm = ($injector) ->
    restrict: 'A'
    require: 'ngModel'  # form data (user input value)
    link: (scope, element, attrs) ->
        name = attrs.fbForm
        console.log 'form'

fbForm.$inject = ['$injector']
a.directive 'fbForm', fbForm

