
# ----------------------------------------
# builder.directive
# ----------------------------------------
a = angular.module 'builder.directive', ['builder.provider', 'builder.controller', 'builder.drag']

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
        # ----------------------------------------
        # providers
        # ----------------------------------------
        $drag = $injector.get '$drag'

        $drag.draggable $(element),
            mode: 'mirror'

fbDraggableMaternal.$inject = ['$injector']
a.directive 'fbDraggableMaternal', fbDraggableMaternal

# ----------------------------------------
# fb-draggable
# ----------------------------------------
fbDraggable = ($injector) ->
    restrict: 'A'
    link: (scope, element) ->
        # ----------------------------------------
        # providers
        # ----------------------------------------
        $drag = $injector.get '$drag'

        $drag.draggable $(element)

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

