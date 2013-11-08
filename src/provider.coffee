
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
    # forms
    #   builder mode: `fb-builder` you could drag and drop to build the form.
    #   form mode: `fb-form` this is the form for user to input value.
    @forms = {}
    @forms[''] = []


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
            required: component.required ? false
            validation: component.validation ? /.*/
            options: component.options ? []
            template: component.template ?
                """
                <div class="form-group">
                    <label for="{{name+label}}" ng-bind="label" class="col-md-2 control-label"></label>
                    <div class="col-md-10">
                        <input type="text" validator="{{validation}}" class="form-control" id="{{name+label}}" placeholder="{{placeholder}}"/>
                    </div>
                </div>
                """

        result

    @convertFormGroup = (formGroup={}) ->
        formGroup


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
            template: html template
        ###
        @components[name] = @convertComponent name, component

    @getComponentGroups = =>
        groupSet = {}
        for name, component of @components
            groupSet[component.group] = null
        Object.keys groupSet

    @addFormGroup = (name, formGroup={}) =>
        ###
        Add the form group into the form.
        @param name: The form name.
        @param formGroup: The form group.
            removable: true
            label:
        ###
        @forms[name] ?= []
        @forms[name].push @convertFormGroup(formGroup)


    # ----------------------------------------
    # $get
    # ----------------------------------------
    @get = ($injector) ->
        @setupProviders $injector

        components: @components
        forms: @forms
        registerComponent: @registerComponent
        getComponentGroups: @getComponentGroups
        addFormGroup: @addFormGroup
    @get.$inject = ['$injector']
    @$get = @get
    return
