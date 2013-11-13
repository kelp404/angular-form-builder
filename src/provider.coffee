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
            validation: component.validation ? /.*/
            options: component.options ? []
            template: component.template ?
                """
                <div class="form-group">
                    <label for="{{name+label}}" class="col-md-2 control-label">{{label}}</label>
                    <div class="col-md-10">
                        <input type="text" class="form-control" id="{{name+label}}" placeholder="{{placeholder}}"/>
                    </div>
                </div>
                """
        result

    @convertFormObject = (formObject={}) ->
        component = @components[formObject.component]
        console.error "component #{formObject.component} was not registered." if not component?
        result =
            component: formObject.component
            removable: formObject.removable ? yes
            draggable: formObject.draggable ? yes
            index: formObject.index ? 0
            label: formObject.label ? component.label
            description: formObject.description ? component.description
            placeholder: formObject.placeholder ? component.placeholder
            options: formObject.options ? component.options
            required: formObject.required ? component.required
        result


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
            validation: RegExp
            options: []
            template: html template
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
        Add the form object into the form.
        @param name: The form name.
        @param form: The form object.
            component: The component name
            removable: true
            draggable: true
            index: 0
            label:
            description:
            placeholder:
            options:
            required:
        ###
        @forms[name] ?= []
        @forms[name].push @convertFormObject(formObject)


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
    @get.$inject = ['$injector']
    @$get = @get
    return
