
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
        $drag = $injector.get '$drag'

        # ----------------------------------------
        # valuables
        # ----------------------------------------
        scope.formName = attrs.fbBuilder
        $builder.forms[scope.formName] ?= []
        scope.form = $builder.forms[scope.formName]

        $(element).addClass 'fb-builder'
        $drag.droppable $(element),
            mode: 'custom'
            move: (e, draggable) ->
                $components = $(element).find '.fb-component:not(.empty,.dragging)'
                if $components.length is 0
                    # there are no components in the builder.
                    if $(element).find('.fb-component.empty') is 0
                        $(element).append $("<div class='fb-component empty'></div>")
                    return

                # the positions could added .empty div.
                positions = []
                # first
                positions.push -1000
                positions.push $($components[0]).offset().top + $($components[0]).height() / 2
                for index in [0..$components.length - 1]
                    continue if index is 0
                    $component = $($components[index])
                    offset = $component.offset()
                    height = $component.height()
                    positions.push offset.top + height / 2
                positions.push positions[positions.length - 1] + 1000   # last

                # search where should I insert the .empty
                for index in [0..positions.length - 1]
                    continue if index is 0
                    if e.pageY > positions[index - 1] and e.pageY <= positions[index]
                        # this one
                        $(element).find('.empty').remove()
                        $empty = $ "<div class='fb-component empty'></div>"
                        if index - 1 < $components.length
                            $empty.insertBefore $($components[index - 1])
                        else
                            $empty.insertAfter $($components[index - 2])
                        break
                return
            out: (e, draggable) ->
                $(element).find('.empty').remove()
            up: (e, draggable) ->
                $(element).find('.empty').remove()
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

