
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
                console.log 'up'
                console.log draggable
                $(element).find('.empty').remove()
fbBuilder.$inject = ['$injector']
a.directive 'fbBuilder', fbBuilder

# ----------------------------------------
# fb-form-object
# ----------------------------------------
fbFormObject = ($injector) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        # providers
        $builder = $injector.get '$builder'
        $drag = $injector.get '$drag'
        $parse = $injector.get '$parse'
        $compile = $injector.get '$compile'

        # valuables
        component = $builder.components[scope.object.component]
        for key, value of scope.object when key isnt '$$hashKey'
            # ng-repeat="object in formObjects"
            # copy scope.object.{} to scope.{}
            scope[key] = value
        scope.$watch '[label, description, placeholder, required, options]', ->
            scope.object.label = scope.label
            scope.object.description = scope.description
            scope.object.placeholder = scope.placeholder
            scope.object.required = scope.required
            scope.object.options = scope.options
        , yes

        # draggable
        $drag.draggable $(element)

        # compile formObject
        $template = $(component.template)
        view = $compile($template) scope
        $(element).append view

        $(element).on 'click', ->
            # hide other popovers
            $("div.fb-form-object:not(.#{popoverId})").popover 'hide'
            return no

        # ----------------------------------------
        # bootstrap popover
        # ----------------------------------------
        popoverId = "fb-#{Math.random().toString().substr(2)}"
        popover =
            view: null
            html: component.popoverTemplate
        popover.html = $(popover.html).addClass popoverId
        scope.popover =
            ngModel: null
            save: ($event) ->
                ###
                The save event of the popover.
                ###
                $event.preventDefault()
                $(element).popover 'hide'
                return
            remove: ($event) ->
                ###
                The delete event of the popover.
                ###
                $event.preventDefault()
                console.log 'remove'
                $(element).popover 'hide'
                return
            shown: ->
                ###
                The shown event of the popover.
                ###
                # copy model for revivification
                @ngModel =
                    label: scope.label
                    description: scope.description
                    placeholder: scope.placeholder
                    required: scope.required
                    options: (x for x in scope.options)
            cancel: ($event) ->
                ###
                The cancel event of the popover.
                ###
                $event.preventDefault()
                scope.label = @ngModel.label
                scope.description = @ngModel.description
                scope.placeholder = @ngModel.placeholder
                scope.required = @ngModel.required
                scope.options.length = 0
                scope.options.push(x) for x in @ngModel
                $(element).popover 'hide'
                return
        # compile popover
        popover.view = $compile(popover.html) scope
        $(element).addClass popoverId
        $(element).popover
            html: yes
            title: component.label
            content: popover.view
        # ----------------------------------------
        # show
        # ----------------------------------------
        $(element).on 'show.bs.popover', ->
            return no if $drag.isMouseMoved()
            $popover = $("form.#{popoverId}").closest '.popover'
            if $popover.length > 0
                $popover.show()
                setTimeout ->
                    $popover.addClass 'in'
                    $(element).triggerHandler 'shown.bs.popover'
                , 0
                no
        # ----------------------------------------
        # shown
        # ----------------------------------------
        $(element).on 'shown.bs.popover', ->
            # select the first input
            $(".popover .#{popoverId} input:first").select()
            scope.$apply -> scope.popover.shown()
        # ----------------------------------------
        # hide
        # ----------------------------------------
        $(element).on 'hide.bs.popover', ->
            # do not remove the DOM
            $popover = $("form.#{popoverId}").closest '.popover'
            $popover.removeClass 'in'
            setTimeout ->
                $popover.hide()
            , 300
            no
fbFormObject.$inject = ['$injector']
a.directive 'fbFormObject', fbFormObject


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
# fb-component
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
        component = $parse(attrs.fbComponent) scope
        $.extend cs, component

        $drag.draggable $(element),
            mode: 'mirror'
            defer: no

        $template = $(component.template)
        view = $compile($template) cs
        $(element).append view
fbComponent.$inject = ['$injector']
a.directive 'fbComponent', fbComponent


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

