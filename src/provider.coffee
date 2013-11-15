###
    component:
        It is like a class.
        The base components are textInput, textArea, select, check, radio.
        User can custom the form with components.
    formObject:
        It is like an object (an instance of the component).
        User can custom the label, description, required and validation of the input.
    form:
        This is for end-user. There are form groups int the form.
        They can input the value to the form.
###

a = angular.module 'builder.provider', []

a.provider '$builder', ->
    # ----------------------------------------
    # providers
    # ----------------------------------------
    $injector = null


    # ----------------------------------------
    # properties
    # ----------------------------------------
    # all components
    @components = {}
    @componentsArray = []
    # all groups of components
    @groups = []

    # forms
    #   builder mode: `fb-builder` you could drag and drop to build the form.
    #   form mode: `fb-form` this is the form for user to input value.
    @forms = {}
    @forms['default'] = []


    # ----------------------------------------
    # private functions
    # ----------------------------------------
    @setupProviders = (injector) ->
        $injector = injector

    @convertComponent = (name, component) ->
        result =
            name: name
            group: component.group ? 'Default'
            label: component.label ? ''
            description: component.description ? ''
            placeholder: component.placeholder ? ''
            required: component.required ? no
            validation: component.validation ? '/.*/'
            errorMessage: component.errorMessage ? ''
            options: component.options ? []
            template: component.template
            popoverTemplate: component.popoverTemplate
        if not result.template then console.error "template is empty"
        if not result.popoverTemplate then console.error "popoverTemplate is empty"
        result

    @convertFormObject = (name, formObject={}) ->
        component = @components[formObject.component]
        console.error "component #{formObject.component} was not registered." if not component?
        result =
            name: name
            component: formObject.component
            draggable: formObject.draggable ? yes
            index: formObject.index ? 0
            label: formObject.label ? component.label
            description: formObject.description ? component.description
            placeholder: formObject.placeholder ? component.placeholder
            options: formObject.options ? component.options
            required: formObject.required ? component.required
            validation: formObject.validation ? component.validation
            errorMessage: formObject.errorMessage ? component.errorMessage
        result

    @reIndexFormObject = (name) =>
        formObjects = @forms[name]
        for index in [0..formObjects.length - 1] by 1
            formObjects[index].index = index
        return

    # ----------------------------------------
    # public functions
    # ----------------------------------------
    @registerComponent = (name, component={}) =>
        ###
        Register the component for form-builder.
        @param name: The component name.
        @param component: The component object.
            group: The compoent group.
            label: The label of the input.
            descriptiont: The description of the input.
            placeholder: The placeholder of the input.
            required: yes / no
            validation: angular-validator
            errorMessage: validator error message
            options: []
            template: html template
            popoverTemplate: html template
        ###
        if not @components[name]?
            # regist the new component
            newComponent = @convertComponent name, component
            @components[name] = newComponent
            @componentsArray.push newComponent
            if newComponent.group not in @groups
                @groups.push newComponent.group
        else
            console.error "The component #{name} was registered."
        return

    @addFormObject = (name, formObject={}) =>
        ###
        Insert the form Object into the form at last.
        ###
        @forms[name] ?= []
        @insertFormObject name, @forms[name].length, formObject

    @insertFormObject = (name, index, formObject={}) =>
        ###
        Insert the form object into the form at {index}.
        @param name: The form name.
        @param form: The form object.
            component: The component name
            draggable: yes
            index: 0
            label:
            description:
            placeholder:
            options:
            required:
            validation: RegExp
        ###
        @forms[name] ?= []
        if index > @forms.length then index = @forms.length
        else if index < 0 then index = 0
        @forms[name].splice index, 0, @convertFormObject(name, formObject)
        @reIndexFormObject name

    @removeFormObject = (name, index) =>
        ###
        Remove the form object by the index.
        @param name: The form name.
        @param index: The form object index.
        ###
        formObjects = @forms[name]
        formObjects.splice index, 1
        @reIndexFormObject name

    @updateFormObjectIndex = (name, oldIndex, newIndex) =>
        ###
        Update the index of the form object.
        @param name: The form name.
        @param oldIndex: The old index.
        @param newIndex: The new index.
        ###
        return if oldIndex is newIndex
        formObjects = @forms[name]
        formObject = formObjects.splice(oldIndex, 1)[0]
        formObjects.splice newIndex, 0, formObject
        @reIndexFormObject name

    # ----------------------------------------
    # $get
    # ----------------------------------------
    @get = ($injector) ->
        @setupProviders $injector

        components: @components
        componentsArray: @componentsArray
        groups: @groups
        forms: @forms
        registerComponent: @registerComponent
        addFormObject: @addFormObject
        insertFormObject: @insertFormObject
        removeFormObject: @removeFormObject
        updateFormObjectIndex: @updateFormObjectIndex
    @get.$inject = ['$injector']
    @$get = @get
    return
