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
        it 'check $builder.components is empty', inject ($builder) ->
            expect(0).toBe Object.keys($builder.components).length


    describe '$builder.groups', ->
        it 'check $builder.groups is empty', inject ($builder) ->
            expect([]).toEqual $builder.groups

        it 'check $builder.groups will be updated after registerComponent()', inject ($builder) ->
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
        it 'check $builder.broadcastChannel', inject ($builder) ->
            expect
                updateInput: '$updateInput'
            .toEqual $builder.broadcastChannel


    describe '$builder.forms', ->
        it 'check $builder.forms', inject ($builder) ->
            expect
                default: []
            .toEqual $builder.forms


    describe '$builderProvider.formsId', ->
        it 'check $builderProvider.formsId', ->
            expect
                default: 0
            .toEqual builderProvider.formsId


    describe '$builderProvider.convertComponent', ->
        it 'check $builderProvider.convertComponent() argument without template', ->
            spyOn(console, 'error').andCallFake (msg) ->
                expect(msg).toEqual 'template is empty'
            builderProvider.convertComponent 'inputText',
                popoverTemplate: "<div class='form-group'></div>"
            expect(console.error).toHaveBeenCalled()

        it 'check $builderProvider.convertComponent() argument without popoverTemplate', ->
            spyOn(console, 'error').andCallFake (msg) ->
                expect(msg).toEqual 'popoverTemplate is empty'
            builderProvider.convertComponent 'inputText',
                template: "<div class='form-group'></div>"
            expect(console.error).toHaveBeenCalled()

        it 'check $builderProvider.convertComponent() with default', ->
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
                errorMessage: ''
                options: []
                arrayToText: no
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            .toEqual component

        it 'check $builderProvider.convertComponent()', ->
            component = builderProvider.convertComponent 'inputText',
                group: 'GroupA'
                label: 'Input Text'
                description: 'description'
                placeholder: 'placeholder'
                editable: no
                required: yes
                validation: '/regexp/'
                errorMessage: 'error message'
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
                errorMessage: 'error message'
                options: ['value one']
                arrayToText: yes
                template: "<div class='form-group'></div>"
                popoverTemplate: "<div class='form-group'></div>"
            .toEqual component
