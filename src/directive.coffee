
# ----------------------------------------
# builder.directive
# ----------------------------------------
a = angular.module 'builder.directive', ['builder.provider', 'builder.controller', 'builder.drag']


# ----------------------------------------
# fb-builder
# ----------------------------------------
fbBuilder = ($injector) ->
    restrict: 'A'
    template:
        """
        <div class='form-horizontal'>
            <div class='fb-form-object-editable' ng-repeat="object in formObjects"
                fb-form-object-editable="object"></div>
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
        formName = attrs.fbBuilder
        $builder.forms[formName] ?= []
        scope.formObjects = $builder.forms[formName]
        beginMove = yes

        $(element).addClass 'fb-builder'
        $drag.droppable $(element),
            mode: 'custom'
            move: (e, draggable) ->
                if beginMove
                    # hide all popovers
                    $("div.fb-form-object-editable").popover 'hide'
                    beginMove = no

                $formObjects = $(element).find '.fb-form-object-editable:not(.empty,.dragging)'
                if $formObjects.length is 0
                    # there are no components in the builder.
                    if $(element).find('.fb-form-object-editable.empty').length is 0
                        $(element).find('>div:first').append $("<div class='fb-form-object-editable empty'></div>")
                    return

                # the positions could added .empty div.
                positions = []
                # first
                positions.push -1000
                positions.push $($formObjects[0]).offset().top + $($formObjects[0]).height() / 2
                for index in [0..$formObjects.length - 1] by 1
                    continue if index is 0
                    $formObject = $($formObjects[index])
                    offset = $formObject.offset()
                    height = $formObject.height()
                    positions.push offset.top + height / 2
                positions.push positions[positions.length - 1] + 1000   # last

                # search where should I insert the .empty
                for index in [0..positions.length - 1] by 1
                    continue if index is 0
                    if e.pageY > positions[index - 1] and e.pageY <= positions[index]
                        # this one
                        $(element).find('.empty').remove()
                        $empty = $ "<div class='fb-form-object-editable empty'></div>"
                        if index - 1 < $formObjects.length
                            $empty.insertBefore $($formObjects[index - 1])
                        else
                            $empty.insertAfter $($formObjects[index - 2])
                        break
                return
            out: (e, draggable) ->
                if beginMove
                    # hide all popovers
                    $("div.fb-form-object-editable").popover 'hide'
                    beginMove = no

                $(element).find('.empty').remove()
            up: (e, isHover, draggable) ->
                beginMove = yes
                # click event
                return if not $drag.isMouseMoved()

                if not isHover and draggable.mode is 'drag'
                    # remove the form object by draggin out
                    formObject = draggable.object.formObject
                    $builder.removeFormObject formObject.name, formObject.index
                else if isHover
                    if draggable.mode is 'mirror'
                        # insert a form object
                        $builder.insertFormObject formName, $(element).find('.empty').index('.fb-form-object-editable'),
                            component: draggable.object.componentName
                    if draggable.mode is 'drag'
                        # update the index of form objects
                        oldIndex = draggable.object.formObject.index
                        newIndex = $(element).find('.empty').index('.fb-form-object-editable')
                        newIndex-- if oldIndex < newIndex
                        $builder.updateFormObjectIndex formName, oldIndex, newIndex
                $(element).find('.empty').remove()
fbBuilder.$inject = ['$injector']
a.directive 'fbBuilder', fbBuilder

# ----------------------------------------
# fb-form-object-editable
# ----------------------------------------
fbFormObjectEditable = ($injector) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        # providers
        $builder = $injector.get '$builder'
        $drag = $injector.get '$drag'
        $parse = $injector.get '$parse'
        $compile = $injector.get '$compile'
        $validator = $injector.get '$validator'

        # get formObject
        formObject = $parse(attrs.fbFormObjectEditable) scope
        # get component
        component = $builder.components[formObject.component]
        for key, value of formObject when key isnt '$$hashKey'
            # ng-repeat="object in formObjects"
            # copy formObject.{} to scope.{}
            scope[key] = value
        scope.optionsText = formObject.options.join '\n'
        scope.$watch '[label, description, placeholder, required, options]', ->
            formObject.label = scope.label
            formObject.description = scope.description
            formObject.placeholder = scope.placeholder
            formObject.required = scope.required
            formObject.options = scope.options
        , yes
        scope.$watch 'optionsText', (text) ->
            scope.options = (x for x in text.split('\n') when x.length > 0)
            scope.inputText = scope.options[0]

        # draggable
        $drag.draggable $(element),
            object:
                formObject: formObject

        # compile formObject
        $template = $(component.template)
        view = $compile($template) scope
        $(element).append view

        # disable click event
        $(element).on 'click', -> no

        # ----------------------------------------
        # bootstrap popover
        # ----------------------------------------
        popoverId = "fb-#{Math.random().toString().substr(2)}"
        popover =
            isClickedSave: no # If didn't click save then rollback
            view: null
            html: component.popoverTemplate
        popover.html = $(popover.html).addClass popoverId
        scope.popover =
            ngModel: null   # data for rollback
            save: ($event) ->
                ###
                The save event of the popover.
                ###
                $event.preventDefault()
                $validator.validate(scope).success ->
                    popover.isClickedSave = yes
                    $(element).popover 'hide'
                return
            remove: ($event) ->
                ###
                The delete event of the popover.
                ###
                $event.preventDefault()

                # get the form name
                formName = $(element).closest('[fb-builder]').attr 'fb-builder'
                $builder.removeFormObject formName, scope.$index
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
                    optionsText: scope.optionsText
                popover.isClickedSave = no
            cancel: ($event) ->
                ###
                The cancel event of the popover.
                ###
                if @ngModel
                    scope.label = @ngModel.label
                    scope.description = @ngModel.description
                    scope.placeholder = @ngModel.placeholder
                    scope.required = @ngModel.required
                    scope.optionsText = @ngModel.optionsText
                if $event
                    # clicked cancel by user
                    $event.preventDefault()
                    $(element).popover 'hide'
                return
        # compile popover
        popover.view = $compile(popover.html) scope
        $(element).addClass popoverId
        $(element).popover
            html: yes
            title: component.label
            content: popover.view
            container: 'body'
        # ----------------------------------------
        # show
        # ----------------------------------------
        $(element).on 'show.bs.popover', ->
            return no if $drag.isMouseMoved()
            # hide other popovers
            $("div.fb-form-object-editable:not(.#{popoverId})").popover 'hide'

            $popover = $("form.#{popoverId}").closest '.popover'
            if $popover.length > 0
                # fixed offset
                elementOrigin = $(element).offset().top + $(element).height() / 2
                popoverTop = elementOrigin - $popover.height() / 2
                $popover.css
                    position: 'absolute'
                    top: popoverTop

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
            return
        # ----------------------------------------
        # hide
        # ----------------------------------------
        $(element).on 'hide.bs.popover', ->
            # do not remove the DOM
            $popover = $("form.#{popoverId}").closest '.popover'
            if not popover.isClickedSave
                # eval the cancel event
                if scope.$$phase
                    scope.popover.cancel()
                else
                    scope.$apply -> scope.popover.cancel()
            $popover.removeClass 'in'
            setTimeout ->
                $popover.hide()
            , 300
            no
fbFormObjectEditable.$inject = ['$injector']
a.directive 'fbFormObjectEditable', fbFormObjectEditable


# ----------------------------------------
# fb-components
# ----------------------------------------
fbComponents = ->
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
            object:
                componentName: component.name

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
    require: 'ngModel'  # form data (end-user input value)
    scope:
        # input model for scops in ng-repeat
        input: '=ngModel'
    template:
        """
        <div class='fb-form-object' ng-repeat="object in form" fb-form-object="object">
        </div>
        """
    controller: 'fbFormController'
    link: (scope, element, attrs) ->
        # providers
        $builder = $injector.get '$builder'

        # form name
        formName = attrs.fbForm
        scope.form = $builder.forms[formName]

        scope.$watch 'form', ->
            # remove superfluous input
            if scope.input.length > scope.form.length
                scope.input.splice scope.form.length
            # tell children to update input value
            scope.$broadcast $builder.broadcastChannel.updateInput
        , yes

fbForm.$inject = ['$injector']
a.directive 'fbForm', fbForm

# ----------------------------------------
# fb-form-object
# ----------------------------------------
fbFormObject = ($injector) ->
    restrict: 'A'
    scope:
        formObject: '=fbFormObject'
    link: (scope, element, attrs) ->
        # providers
        $builder = $injector.get '$builder'
        $compile = $injector.get '$compile'

        # get component
        component = $builder.components[scope.formObject.component]

        # copy current scope.input[X] to $parent.input
        updateInput = ->
            input =
                label: scope.formObject.label
                value: ''
            input.value = scope.inputText if scope.inputText
            scope.$parent.input.splice scope.$index, 1, input

        for key, value of scope.formObject when key isnt '$$hashKey'
            # ng-repeat="object in form"
            # copy formObject.{} to scope.{}
            scope[key] = value

        # listen (formObject updated
        scope.$on $builder.broadcastChannel.updateInput, -> updateInput()
        # watch (end-user updated form
        scope.$watch '[inputText]', ->
            updateInput()
        , yes

        # compile
        view = $compile(component.template) scope
        $(element).append view

        # execute updateInput() for set-up
        updateInput()

fbFormObject.$inject = ['$injector']
a.directive 'fbFormObject', fbFormObject

