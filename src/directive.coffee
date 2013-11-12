
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
            <div class='fb-form-object' ng-repeat="object in formObjects"
                fb-form-object="object"></div>
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
        scope.formObjects = $builder.forms[scope.formName]

        $(element).addClass 'fb-builder'
        $drag.droppable $(element),
            mode: 'custom'
            move: (e, draggable) ->
                $formObjects = $(element).find '.fb-form-object:not(.empty,.dragging)'
                if $formObjects.length is 0
                    # there are no components in the builder.
                    if $(element).find('.fb-form-object.empty') is 0
                        $(element).append $("<div class='fb-form-object empty'></div>")
                    return

                # the positions could added .empty div.
                positions = []
                # first
                positions.push -1000
                positions.push $($formObjects[0]).offset().top + $($formObjects[0]).height() / 2
                for index in [0..$formObjects.length - 1]
                    continue if index is 0
                    $formObject = $($formObjects[index])
                    offset = $formObject.offset()
                    height = $formObject.height()
                    positions.push offset.top + height / 2
                positions.push positions[positions.length - 1] + 1000   # last

                # search where should I insert the .empty
                for index in [0..positions.length - 1]
                    continue if index is 0
                    if e.pageY > positions[index - 1] and e.pageY <= positions[index]
                        # this one
                        $(element).find('.empty').remove()
                        $empty = $ "<div class='fb-form-object empty'></div>"
                        if index - 1 < $formObjects.length
                            $empty.insertBefore $($formObjects[index - 1])
                        else
                            $empty.insertAfter $($formObjects[index - 2])
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
                fb-component="component"></div>
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
        $drag = $injector.get '$drag'
        $parse = $injector.get '$parse'
        $compile = $injector.get '$compile'

        # valuables
        cs = scope.$new()   # component scope
        if attrs.fbComponent
            component = $parse(attrs.fbComponent) scope
            $.extend cs, component

            $drag.draggable $(element),
                mode: 'mirror'
                defer: no
        else
            formObject = $parse(attrs.fbFormObject) scope
            component = $builder.components[formObject.component]
            $.extend cs, formObject

            $(element).on 'click', ->
                console.log 'click'
            $drag.draggable $(element)

        $template = $(component.template)
        view = $compile($template) cs
        $(element).append view
fbComponent.$inject = ['$injector']
a.directive 'fbComponent', fbComponent
a.directive 'fbFormObject', fbComponent


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

