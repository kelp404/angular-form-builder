describe 'builder.controller', ->
    beforeEach module('builder')


    describe 'fbFormObjectEditableController', ->
        $scope = null
        controller = null

        beforeEach inject ($rootScope, $controller, $builder, $injector) ->
            $builder.registerComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

            $scope = $rootScope.$new()
            controller = $controller 'fbFormObjectEditableController',
                $scope: $scope
                $injector: $injector

        describe '$scope.setupScope()', ->
            formObject = null

            beforeEach ->
                formObject =
                    $$hashKey: '007'
                    component: 'inputText'
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    options: ['value one', 'two']
                    validation: '/.*/'
                $scope.setupScope formObject

            it '$scope.setupScope(formObject) copy properties from formObject without `$$hashKey`', ->
                expect($scope.$$hashKey).toBeUndefined()
                expect(formObject.label).toEqual $scope.label
                expect(formObject.description).toEqual $scope.description
                expect(formObject.placeholder).toEqual $scope.placeholder
                expect(formObject.required).toBe no
                expect(formObject.options).toEqual $scope.options
                expect(formObject.validation).toEqual $scope.validation

            it '$scope.setupScope(formObject) $scope.optionsText is joined by `\\n` from options', ->
                expect($scope.optionsText).toEqual 'value one\ntwo'

            it '$scope.setupScope(formObject) $scope.$watch `[label, description, placeholder, required, options, validation]`', ->
                $scope.label = 'new'
                $scope.$digest()
                expect(formObject.label).toEqual $scope.label

                $scope.description = 'new'
                $scope.$digest()
                expect(formObject.description).toEqual $scope.description

                $scope.placeholder = 'new'
                $scope.$digest()
                expect(formObject.placeholder).toEqual $scope.placeholder

                $scope.required = yes
                $scope.$digest()
                expect(formObject.required).toBe $scope.required

                $scope.options = ['value']
                $scope.$digest()
                expect(formObject.options).toEqual $scope.options

                $scope.validation = '/regex/'
                $scope.$digest()
                expect(formObject.validation).toEqual $scope.validation

            it '$scope.setupScope(formObject) $scope.$watch `optionsText`', ->
                $scope.optionsText = "one\ntwo"
                $scope.$digest()
                expect(['one', 'two']).toEqual $scope.options
                expect('one').toEqual $scope.inputText

            it '$scope.setupScope(formObject) setup validationOptions', ->
                expect([]).toEqual $scope.validationOptions

        describe '$scope.data', ->
            formObject = null

            beforeEach ->
                formObject =
                    $$hashKey: '007'
                    component: 'inputText'
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    options: ['value one', 'two']
                    validation: '/.*/'
                $scope.setupScope formObject

            it '$scope.data.model is null', ->
                expect($scope.data.model).toBeNull()

            it '$scope.data.model after call $scope.data.backup()', ->
                $scope.data.backup()
                expect
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    optionsText: 'value one\ntwo'
                    validation: '/.*/'
                .toEqual $scope.data.model

            it '$scope after call $scope.data.rollback()', ->
                $scope.data.backup()
                $scope.label = ''
                $scope.description = ''
                $scope.placeholder = ''
                $scope.required = yes
                $scope.optionsText = ''
                $scope.data.rollback()
                $scope.$digest()
                expect(formObject.label).toEqual $scope.label
                expect(formObject.description).toEqual $scope.description
                expect(formObject.placeholder).toEqual $scope.placeholder
                expect(formObject.required).toEqual $scope.required
                expect(formObject.options.join('\n')).toEqual $scope.optionsText


    describe 'fbComponentsController', ->
        $scope = null
        controller = null

        beforeEach inject ($rootScope, $controller, $builder) ->
            $builder.registerComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

            $scope = $rootScope.$new()
            controller = $controller 'fbComponentsController',
                $scope: $scope

        describe '$scope.groups', ->
            it '$scope.groups is equal to $builder.groups', inject ($builder) ->
                expect($scope.groups).toBe $builder.groups

        describe '$scope.activeGroups', ->
            it '$scope.activeGroup is the first on of $scope.groups', inject ->
                expect($scope.activeGroup).toBe $scope.groups[0]

        describe '$scope.allComponents', ->
            it '$scope.allComponents is equal to $builder.components', inject ($builder) ->
                expect($scope.allComponents).toBe $builder.components

            it '$watch $scope.allComponents than call $scope.selectGroup', inject ($builder) ->
                spyOn($scope, 'selectGroup').and.callFake ($event, activeGroup) ->
                    expect($event).toBeNull()
                    expect($scope.activeGroup).toEqual activeGroup
                $builder.registerComponent 'newComponent',
                    template: "<div class='form-group'></div>"
                    popoverTemplate: "<div class='form-group'></div>"
                $scope.$digest()
                expect($scope.selectGroup).toHaveBeenCalled()

        describe '$scope.activeGroup()', ->
            it '$scope.selectGroup will update activeGroup and components', inject ($builder) ->
                $builder.registerComponent 'xComponent',
                    group: 'X'
                    template: "<div class='form-group'></div>"
                    popoverTemplate: "<div class='form-group'></div>"
                $scope.$digest()

                $event = preventDefault: jasmine.createSpy 'preventDefault'
                $scope.selectGroup $event, 'X'
                expect($event.preventDefault).toHaveBeenCalled()
                expect($scope.activeGroup).toEqual 'X'
                expect($scope.components.length).toBe 1
                expect($scope.components[0].name).toEqual 'xComponent'


    describe 'fbComponentController', ->
        $scope = null
        controller = null

        beforeEach inject ($rootScope, $controller) ->
            $scope = $rootScope.$new()
            controller = $controller 'fbComponentController',
                $scope: $scope

        describe '$scope.copyObjectToScope()', ->
            component = null

            beforeEach ->
                component =
                    $$hashKey: '007'
                    name: 'textInput'
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    options: ['value one', 'two']
                    template: "<div class='form-group'></div>"
                    popoverTemplate: "<div class='form-group'></div>"

            it '$scope.copyObjectToScope(component) copy properties to $scope without `$$hashKey`', ->
                $scope.copyObjectToScope component
                expect($scope.$$hashKey).toBeUndefined()
                expect(component.name).toEqual $scope.name
                expect(component.label).toEqual $scope.label
                expect(component.description).toEqual $scope.description
                expect(component.placeholder).toEqual $scope.placeholder
                expect(component.required).toBe no
                expect(component.options).toEqual $scope.options
                expect(component.template).toEqual $scope.template
                expect(component.popoverTemplate).toEqual $scope.popoverTemplate


    describe 'fbFormController', ->
        $timeout = null
        $scope = null
        controller = null

        beforeEach inject ($rootScope, $controller, $injector) ->
            $timeout = $injector.get '$timeout'
            $scope = $rootScope.$new()
            controller = $controller 'fbFormController',
                $scope: $scope
                $injector: $injector

        describe "$scope.$watch('form')", ->
            it "$scope.$watch('form') remove superfluous input and $broadcast", inject ($builder) ->
                spyBroadcast = jasmine.createSpy 'broadcast'
                $scope.$on $builder.broadcastChannel.updateInput, ->
                    spyBroadcast()
                $scope.input = [{}, {}]
                $scope.form = [
                    component: 'textbox'
                ]
                $scope.$digest()
                $timeout.flush()
                expect($scope.input.length).toBe 1
                expect(spyBroadcast).toHaveBeenCalled()


    describe 'fbFormObjectController', ->
        $scope = null
        controller = null

        beforeEach inject ($rootScope, $controller, $injector) ->
            $scope = $rootScope.$new()
            controller = $controller 'fbFormObjectController',
                $scope: $scope
                $injector: $injector

        describe '$scope.copyObjectToScope()', ->
            formObject = null
            beforeEach ->
                formObject =
                    $$hashKey: '007'
                    name: 'textInput'
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    options: ['value one', 'two']
            it '$scope.copyObjectToScope(formObject) copy properties to $scope without `$$hashKey`', ->
                $scope.copyObjectToScope formObject
                expect($scope.$$hashKey).toBeUndefined()
                expect(formObject.name).toEqual $scope.name
                expect(formObject.label).toEqual $scope.label
                expect(formObject.description).toEqual $scope.description
                expect(formObject.placeholder).toEqual $scope.placeholder
                expect(formObject.required).toBe no
                expect(formObject.options).toEqual $scope.options

        describe '$scope.updateInput()', ->
            it '$scope.updateInput(value) will copy input value to $parent.input', ->
                $scope.$parent.input = []
                $scope.$index = 0
                $scope.formObject =
                    id: 0
                    label: 'label'
                $scope.updateInput 'value'
                expect($scope.$parent.input).toEqual [
                    id: 0
                    label: 'label'
                    value: 'value'
                ]

            it '$scope.updateInput(value) will copy input value to $parent.input with default', ->
                $scope.$parent.input = []
                $scope.$index = 0
                $scope.formObject =
                    id: 0
                    label: 'label'
                $scope.updateInput()
                expect($scope.$parent.input).toEqual [
                    id: 0
                    label: 'label'
                    value: ''
                ]
