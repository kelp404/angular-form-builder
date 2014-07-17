describe 'builder.provider', ->
    fakeModule = null
    builderProvider = null

    beforeEach module('builder')
    beforeEach ->
        fakeModule = angular.module 'fakeModule', ['builder']
        fakeModule.config ($builderProvider) ->
            builderProvider = $builderProvider
    beforeEach module('fakeModule')


    # ----------------------------------------
    # properties
    # ----------------------------------------
    describe '$builder.components', ->
        it '$builder.components is empty', inject ($builder) ->
            expect(0).toBe Object.keys($builder.components).length


    describe '$builder.groups', ->
        it '$builder.groups is empty', inject ($builder) ->
            expect([]).toEqual $builder.groups

        it '$builder.groups will be updated after registerComponent()', inject ($builder) ->
            $builder.registerComponent 'textInput',
                group: 'Default'
                label: 'Text Input'
                description: 'description'
                placeholder: 'placeholder'
                required: no
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            expect(['Default']).toEqual $builder.groups

            $builder.registerComponent 'textArea',
                group: 'Default'
                label: 'Text Area'
                description: 'description'
                placeholder: 'placeholder'
                required: no
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            expect(['Default']).toEqual $builder.groups

            $builder.registerComponent 'textAreaGroupA',
                group: 'GroupA'
                label: 'Text Area'
                description: 'description'
                placeholder: 'placeholder'
                required: no
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            expect(['Default', 'GroupA']).toEqual $builder.groups


    describe '$builder.broadcastChannel', ->
        it '$builder.broadcastChannel', inject ($builder) ->
            expect
                updateInput: '$updateInput'
            .toEqual $builder.broadcastChannel


    describe '$builder.forms', ->
        it '$builder.forms', inject ($builder) ->
            expect
                default: []
            .toEqual $builder.forms


    # ----------------------------------------
    # methods
    # ----------------------------------------
    describe '$builderProvider.convertComponent()', ->
        it '$builderProvider.convertComponent() argument without template', ->
            spyOn(console, 'error').and.callFake (msg) ->
                expect(msg).toEqual 'The template is empty.'
            builderProvider.convertComponent 'inputText',
                popoverTemplate: "<div class='form-group'></div>"
            expect(console.error).toHaveBeenCalled()

        it '$builderProvider.convertComponent() argument without popoverTemplate', ->
            spyOn(console, 'error').and.callFake (msg) ->
                expect(msg).toEqual 'The popoverTemplate is empty.'
            builderProvider.convertComponent 'inputText',
                template: "<div class='form-group'></div>"
            expect(console.error).toHaveBeenCalled()

        it '$builderProvider.convertComponent() with default', ->
            component = builderProvider.convertComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            expect
                name: 'inputText'
                group: 'Default'
                label: ''
                description: ''
                placeholder: ''
                editable: yes
                required: no
                validation: '/.*/'
                validationOptions: []
                options: []
                arrayToText: no
                template: "<div class='form-group'></div>"
                templateUrl: undefined
                popoverTemplate: "<div class='form-group'></div>"
                popoverTemplateUrl: undefined
            .toEqual component

        it '$builderProvider.convertComponent()', ->
            component = builderProvider.convertComponent 'inputText',
                group: 'GroupA'
                label: 'Input Text'
                description: 'description'
                placeholder: 'placeholder'
                editable: no
                required: yes
                validation: '/regexp/'
                validationOptions: []
                options: ['value one']
                arrayToText: yes
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            expect
                name: 'inputText'
                group: 'GroupA'
                label: 'Input Text'
                description: 'description'
                placeholder: 'placeholder'
                editable: no
                required: yes
                validation: '/regexp/'
                validationOptions: []
                options: ['value one']
                arrayToText: yes
                template: "<div class='form-group'></div>"
                templateUrl: undefined
                popoverTemplate: "<div class='form-group'></div>"
                popoverTemplateUrl: undefined
            .toEqual component


    describe '$builderProvider.convertFormObject()', ->
        it '$builderProvider.convertFormObject() argument with the not exist component', ->
            expect ->
                builderProvider.convertFormObject 'default',
                    component: 'input'
            .toThrow()

        it '$builderProvider.convertFormObject() with default value', inject ($builder) ->
            # Register the component `inputText`.
            $builder.registerComponent 'inputText',
                group: 'GroupA'
                label: 'Input Text'
                description: 'description'
                placeholder: 'placeholder'
                editable: yes
                required: yes
                validation: '/regexp/'
                options: ['value one']
                arrayToText: yes
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            formObject = builderProvider.convertFormObject 'default',
                component: 'inputText'

            expect
                id: undefined
                component: 'inputText'
                editable: yes
                index: 0
                label: 'Input Text'
                description: 'description'
                placeholder: 'placeholder'
                options: ['value one']
                required: yes
                validation: '/regexp/'
            .toEqual formObject

        it '$builderProvider.convertFormObject()', inject ($builder) ->
            $builder.registerComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

            formObject = builderProvider.convertFormObject 'default',
                component: 'inputText'
                editable: no
                label: 'input label'
                description: 'description A'
                placeholder: 'placeholder A'
                options: ['value']
                required: no
                validation: '/.*/'

            expect
                id: undefined
                component: 'inputText'
                editable: no
                index: 0
                label: 'input label'
                description: 'description A'
                placeholder: 'placeholder A'
                options: ['value']
                required: no
                validation: '/.*/'
            .toEqual formObject


    describe '$builderProvider.reindexFormObject()', ->
        it '$builderProvider.reindexFormObject()', ->
            builderProvider.forms.default.push index: 0
            builderProvider.forms.default.push index: 0

            calledCount = jasmine.createSpy 'calledCount'
            builderProvider.reindexFormObject 'default'
            for index in [0...builderProvider.forms.default.length] by 1
                formObject = builderProvider.forms.default[index]
                expect(formObject.index).toBe index
                calledCount()
            expect(calledCount.calls.count()).toBe 2


    describe '$builder.registerComponent()', ->
        it '$builder.registerComponent()', inject ($builder) ->
            $builder.registerComponent 'textInput',
                group: 'Default'
                label: ''
                description: ''
                placeholder: ''
                editable: yes
                required: no
                validation: '/.*/'
                options: []
                arrayToText: no
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

            expect
                name: 'textInput'
                group: 'Default'
                label: ''
                description: ''
                placeholder: ''
                editable: yes
                required: no
                validation: '/.*/'
                validationOptions: []
                options: []
                arrayToText: no
                template: "<div class='form-group'></div>"
                templateUrl: undefined
                popoverTemplate: "<div class='form-group'></div>"
                popoverTemplateUrl: undefined
            .toEqual $builder.components.textInput

        it '$builder.registerComponent() the same component will call console.error()', inject ($builder) ->
            $builder.registerComponent 'textInput',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            spyOn(console, 'error').and.callFake (msg) ->
                expect('The component textInput was registered.').toEqual msg
            $builder.registerComponent 'textInput',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            expect(console.error).toHaveBeenCalled()


    describe '$builder.addFormObject()', ->
        beforeEach -> inject ($builder) ->
            $builder.registerComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

        it '$builder.addFormObject() will call $builderProvider.insertFormObject()', inject ($builder) ->
            spyOn(builderProvider, 'insertFormObject').and.callFake (name, index, formObject) ->
                expect(name).toEqual 'default'
                expect(index).toBe 0
                expect
                    component: 'inputText'
                .toEqual formObject
            $builder.addFormObject 'default', component: 'inputText'
            expect(builderProvider.insertFormObject).toHaveBeenCalled()

        it '$builder.addFormObject() add the form object into the new form', inject ($builder) ->
            expect ->
                $builder.addFormObject 'new', component: 'inputText'
            .not.toThrow()

    describe '$builder.insertFormObject()', ->
        beforeEach -> inject ($builder) ->
            $builder.registerComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

        it '$builder.insertFormObject() index out of bound', inject ($builder) ->
            spyOn(builderProvider.forms.default, 'splice').and.callFake (index, length) ->
                expect(index).toBe 0
                expect(length).toBe 0
            $builder.insertFormObject 'default', 1000, component: 'inputText'
            expect(builderProvider.forms.default.splice).toHaveBeenCalled()

        it '$builder.insertFormObject() index less than 0', inject ($builder) ->
            spyOn(builderProvider.forms.default, 'splice').and.callFake (index, length) ->
                expect(index).toBe 0
                expect(length).toBe 0
            $builder.insertFormObject 'default', -1, component: 'inputText'
            expect(builderProvider.forms.default.splice).toHaveBeenCalled()

        it '$builder.insertFormObject()', inject ($builder) ->
            $builder.insertFormObject 'default', 0, component: 'inputText'
            spyOn(builderProvider.forms.default, 'splice').and.callFake (index, length) ->
                expect(index).toBe 1
                expect(length).toBe 0
            $builder.insertFormObject 'default', 1, component: 'inputText'
            expect(builderProvider.forms.default.splice).toHaveBeenCalled()

        it '$builder.insertFormObject() will call convertFormObject() and reindexFormObject()', inject ($builder) ->
            spyOn(builderProvider, 'convertFormObject').and.callFake (name, formObject) ->
                expect(name).toEqual 'default'
                expect
                    component: 'inputText'
                .toEqual formObject
            spyOn(builderProvider, 'reindexFormObject').and.callFake (name) ->
                expect(name).toEqual 'default'
            $builder.insertFormObject 'default', 1, component: 'inputText'
            expect(builderProvider.convertFormObject).toHaveBeenCalled()
            expect(builderProvider.reindexFormObject).toHaveBeenCalled()


    describe '$builder.removeFormObject()', ->
        beforeEach -> inject ($builder) ->
            $builder.registerComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

        it '$builder.removeFormObject() will call formObject.splice() and reindexFormObject()', inject ($builder) ->
            spyOn(builderProvider.forms.default, 'splice').and.callFake (index, length, object) ->
                expect(index).toBe 1
                expect(length).toBe 1
                expect(object).toBeUndefined()
            spyOn(builderProvider, 'reindexFormObject').and.callFake (name) ->
                expect(name).toEqual 'default'
            $builder.removeFormObject 'default', 1
            expect(builderProvider.forms.default.splice).toHaveBeenCalled()
            expect(builderProvider.reindexFormObject).toHaveBeenCalled()


    describe '$builder.updateFormObjectIndex()', ->
        beforeEach -> inject ($builder) ->
            $builder.registerComponent 'inputText',
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"

        it '$builder.updateFormObjectIndex() will directive return if the new index and the old index are the same one', inject ($builder) ->
            spyOn builderProvider.forms.default, 'splice'
            spyOn builderProvider, 'reindexFormObject'
            $builder.updateFormObjectIndex 'default', 0, 0
            expect(builderProvider.forms.default.splice).not.toHaveBeenCalled()
            expect(builderProvider.reindexFormObject).not.toHaveBeenCalled()

        it '$builder.updateFormObjectIndex() will call formObject.splice() and reindexFormObject()', inject ($builder) ->
            formObject = id: 0
            spySplice = spyOn(builderProvider.forms.default, 'splice').and.callFake (index, length, object) ->
                switch spySplice.calls.count()
                    when 1
                        expect(index).toBe 0
                        expect(length).toBe 1
                        expect(object).toBeUndefined()
                        [formObject]
                    when 2
                        expect(index).toBe 1
                        expect(length).toBe 0
                        expect(object).toBe formObject
                    else
            spyOn builderProvider, 'reindexFormObject'
            $builder.updateFormObjectIndex 'default', 0, 1
            expect(spySplice.calls.count()).toBe 2
            expect(builderProvider.reindexFormObject).toHaveBeenCalled()


    describe '$builder.$get()', ->
        it '$builder.config is equal $builderProvider.config', inject ($builder) ->
            expect($builder.config).toBe builderProvider.config
        it '$builder.components is equal $builderProvider.components', inject ($builder) ->
            expect($builder.components).toBe builderProvider.components
        it '$builder.groups is equal $builderProvider.groups', inject ($builder) ->
            expect($builder.groups).toBe builderProvider.groups
        it '$builder.forms is equal $builderProvider.forms', inject ($builder) ->
            expect($builder.forms).toBe builderProvider.forms
        it '$builder.broadcastChannel is equal $builderProvider.broadcastChannel', inject ($builder) ->
            expect($builder.broadcastChannel).toBe builderProvider.broadcastChannel
        it '$builder.registerComponent is equal $builderProvider.registerComponent', inject ($builder) ->
            expect($builder.registerComponent).toBe builderProvider.registerComponent
        it '$builder.addFormObject is equal $builderProvider.addFormObject', inject ($builder) ->
            expect($builder.addFormObject).toBe builderProvider.addFormObject
        it '$builder.insertFormObject is equal $builderProvider.insertFormObject', inject ($builder) ->
            expect($builder.insertFormObject).toBe builderProvider.insertFormObject
        it '$builder.removeFormObject is equal $builderProvider.removeFormObject', inject ($builder) ->
            expect($builder.removeFormObject).toBe builderProvider.removeFormObject
        it '$builder.updateFormObjectIndex is equal $builderProvider.updateFormObjectIndex', inject ($builder) ->
            expect($builder.updateFormObjectIndex).toBe builderProvider.updateFormObjectIndex
