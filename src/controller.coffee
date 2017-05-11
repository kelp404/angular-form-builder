# ----------------------------------------
# Shared functions
# ----------------------------------------
copyObjectToScope = (object, scope) ->
    ###
    Copy object (ng-repeat="object in objects") to scope without `hashKey`.
    ###
    for key, value of object when key isnt '$$hashKey'
        # copy object.{} to scope.{}
        if key != 'options'
            scope[key] = value
        else
            copyObjectOptionsToScopeOptions(value, scope)
    return

copyObjectOptionsToScopeOptions = (options, scope) ->
    scope.options = []
    for option in options
        newOption = option
        unless typeof option == 'string' || option instanceof String
            newOption = {}
            for key, value of option when key isnt '$$hashKey'
                newOption[key] = value
              
        scope.options.push(newOption)

# ----------------------------------------
# builder.controller
# ----------------------------------------
angular.module 'builder.controller', ['builder.provider']

# ----------------------------------------
# fbFormObjectEditableController
# ----------------------------------------
.controller 'fbFormObjectEditableController', ['$scope', '$injector', ($scope, $injector) ->
    $builder = $injector.get '$builder'

    $scope.setupScope = (formObject) ->
        ###
        1. Copy origin formObject (ng-repeat="object in formObjects") to scope.
        2. Watch scope.label, .description, .placeholder, .required, .effectiveDateEnabled, .options then copy to origin formObject.
        3. setup validationOptions
        ###
        copyObjectToScope formObject, $scope

#        $scope.optionsText = formObject.options.join '\n'

        $scope.$watch '[label, description, placeholder, required, effectiveDateEnabled, validation, variables]', ->
            formObject.label = $scope.label
            formObject.description = $scope.description
            formObject.placeholder = $scope.placeholder
            formObject.required = $scope.required
            formObject.effectiveDateEnabled = $scope.effectiveDateEnabled
#            formObject.options = $scope.options
            formObject.restrictReason = $scope.restrictReason
            formObject.validation = $scope.validation
            formObject.variables = $scope.variables
        , yes

        $scope.$watch 'options', ->
            formObject.options = $scope.options
            if ($scope.options?.length > 0)
                $scope.inputText = $scope.options[0].value
        , yes

        component = $builder.components[formObject.component]
        $scope.validationOptions = component.validationOptions

    $scope.data =
        model: null
        backup: ->
            ###
            Backup input value.
            ###
            @model =
                label: $scope.label
                description: $scope.description
                placeholder: $scope.placeholder
                required: $scope.required
                validation: $scope.validation
                restrictReason : $scope.restrictReason
                options: angular.copy($scope.options)
                variables: angular.copy($scope.variables)
        rollback: ->
            ###
            Rollback input value.
            ###
            return if not @model
            $scope.label = @model.label
            $scope.description = @model.description
            $scope.placeholder = @model.placeholder
            $scope.required = @model.required
            $scope.validation = @model.validation
            $scope.restrictReason = @model.restrictReason
            $scope.options = angular.copy(@model.options)
            $scope.variables = angular.copy(@model.variables)
]


# ----------------------------------------
# fbComponentsController
# ----------------------------------------
.controller 'fbComponentsController', ['$scope', '$injector', ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'

    # action
    $scope.selectGroup = ($event, group) ->
        $event?.preventDefault()
        $scope.activeGroup = group
        $scope.components = []
        for name, component of $builder.components when component.group is group
            $scope.components.push component

    $scope.groups = $builder.groups
    $scope.activeGroup = $scope.groups[0]
    $scope.allComponents = $builder.components
    $scope.$watch 'allComponents', -> $scope.selectGroup null, $scope.activeGroup
]


# ----------------------------------------
# fbComponentController
# ----------------------------------------
.controller 'fbComponentController', ['$scope', ($scope) ->
    $scope.copyObjectToScope = (object) -> copyObjectToScope object, $scope
]


# ----------------------------------------
# fbFormController
# ----------------------------------------
.controller 'fbFormController', ['$scope', '$injector', ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'
    $timeout = $injector.get '$timeout'

    # set default for input
    $scope.input ?= []
    $scope.$watch 'form', ->
        # remove superfluous input
        if $scope.input.length > $scope.form.length
            $scope.input.splice $scope.form.length
        # tell children to update input value.
        # ! use $timeout for waiting $scope updated.
        $timeout ->
            $scope.$broadcast $builder.broadcastChannel.updateInput
    , yes
]


# ----------------------------------------
# fbFormObjectController
# ----------------------------------------
.controller 'fbFormObjectController', ['$scope', '$injector', ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'

    $scope.copyObjectToScope = (object) -> copyObjectToScope object, $scope

    $scope.updateInput = (value) ->
        ###
        Copy current scope.input[X] to $parent.input.
        @param value: The input value.
        ###
        input =
            id: $scope.formObject.id
            label: $scope.formObject.label
            value: value ? ''
        $scope.$parent.input.splice $scope.$index, 1, input
]
