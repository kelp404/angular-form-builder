
class Draggable
    constructor: ($injector, object) ->
        @injector = $injector
        @$maternal = null
        @$element = null

        if object.maternal
            # mirror mode
            @$maternal = $(object.maternal)
            @mirrorMode(@$maternal)

    mirrorMode: (maternal) =>
        maternal.bind 'mousedown', (e) =>
            e.preventDefault()
            @$element = maternal.clone()
            callback =
                move: (e) =>
                    @$element.offset
                        left: e.pageX - @$element.width() / 2
                        top: e.pageY - @$element.height() / 2
                up: (e) => @$element.remove()
            @setupElement @$element, callback,
                left: e.pageX - @$maternal.width() / 2
                top: e.pageY - @$maternal.height() / 2

    setupElement: (element, callback, object) =>
        element.addClass 'fb-draggable dragging form-horizontal'
        element.css
            width: @$maternal.width()
            height: @$maternal.height()
            left: object.left ? @$maternal.offset().left
            top: object.top ? @$maternal.offset().top
        element.bind 'mousedown', (e) -> callback.down(e) if callback.down
        element.bind 'mousemove', (e) -> callback.move(e) if callback.move
        element.bind 'mouseup', (e) -> callback.up(e) if callback.up
        $('body').append element


a = angular.module 'builder.directive', ['builder.provider', 'builder.controller']

# ----------------------------------------
# fb-builder
# ----------------------------------------
fbBuilder = ($injector) ->
    restrict: 'A'
    require: 'ngModel'  # builder data (the form information)
    link: (scope, element, attrs) ->
        # ----------------------------------------
        # providers
        # ----------------------------------------
        $parse = $injector.get '$parse'

        # ----------------------------------------
        # valuables
        # ----------------------------------------
        model = $parse attrs.ngModel
        name = attrs.fbBuilder

fbBuilder.$inject = ['$injector']
a.directive 'fbBuilder', fbBuilder


# ----------------------------------------
# fb-components
# ----------------------------------------
fbComponents = ($injector) ->
    restrict: 'A'
    template:
        """
        <div class='fb-components'>
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
        </div>
        """
    controller: 'fbComponentsController'
    link: (scope, element, attrs) ->

fbComponents.$inject = ['$injector']
a.directive 'fbComponents', fbComponents

# ----------------------------------------
# fb-component
# ----------------------------------------
fbComponent = ($injector) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        # providers
        $parse = $injector.get '$parse'
        $compile = $injector.get '$compile'

        # valuables
        component = $parse(attrs.fbComponent) scope
        cs = scope.$new()   # component scope

        $.extend cs, component
        $template = $(component.template)
        view = $compile($template) cs
        $(element).append view
fbComponent.$inject = ['$injector']
a.directive 'fbComponent', fbComponent

# ----------------------------------------
# fb-draggable-maternal
# ----------------------------------------
fbDraggableMaternal = ($injector) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        new Draggable $injector,
            maternal: element

fbDraggableMaternal.$inject = ['$injector']
a.directive 'fbDraggableMaternal', fbDraggableMaternal


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

