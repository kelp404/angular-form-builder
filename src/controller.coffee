
a = angular.module 'builder.controller', ['builder.provider']

copyObjectToScope = (object, scope) ->
    ###
    Copy object (ng-repeat="object in objects") to scope without `hashKey`.
    ###
    for key, value of object when key isnt '$$hashKey'
        # copy object.{} to scope.{}
        scope[key] = value
    return


# ----------------------------------------
# fbFormObjectEditableController
# ----------------------------------------
fbFormObjectEditableController = ($scope) ->
    $scope.setupScope = (formObject) ->
        ###
        1. Copy origin formObject (ng-repeat="object in formObjects") to scope.
        2. Setup optionsText with formObject.options.
        3. Watch scope.label, .description, .placeholder, .required, .options then copy to origin formObject.
        4. Watch scope.optionsText then convert to scope.options.
        ###
        copyObjectToScope formObject, $scope

        $scope.optionsText = formObject.options.join '\n'

        $scope.$watch '[label, description, placeholder, required, options]', ->
            formObject.label = $scope.label
            formObject.description = $scope.description
            formObject.placeholder = $scope.placeholder
            formObject.required = $scope.required
            formObject.options = $scope.options
        , yes

        $scope.$watch 'optionsText', (text) ->
            $scope.options = (x for x in text.split('\n') when x.length > 0)
            $scope.inputText = $scope.options[0]

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
                optionsText: $scope.optionsText
        rollback: ->
            ###
            Rollback input value.
            ###
            return if not @model
            $scope.label = @model.label
            $scope.description = @model.description
            $scope.placeholder = @model.placeholder
            $scope.required = @model.required
            $scope.optionsText = @model.optionsText

fbFormObjectEditableController.$inject = ['$scope']
a.controller 'fbFormObjectEditableController', fbFormObjectEditableController


# ----------------------------------------
# fbComponentsController
# ----------------------------------------
fbComponentsController = ($scope, $injector) ->
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

fbComponentsController.$inject = ['$scope', '$injector']
a.controller 'fbComponentsController', fbComponentsController


# ----------------------------------------
# fbComponentController
# ----------------------------------------
fbComponentController = ($scope) ->
    $scope.copyObjectToScope = (object) -> copyObjectToScope object, $scope

fbComponentController.$inject = ['$scope']
a.controller 'fbComponentController', fbComponentController


# ----------------------------------------
# fbFormController
# ----------------------------------------
fbFormController = ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'
    $timeout = $injector.get '$timeout'

    $scope.$watch 'form', ->
        # remove superfluous input
        if $scope.input.length > $scope.form.length
            $scope.input.splice $scope.form.length
        # tell children to update input value
        $timeout -> $scope.$broadcast $builder.broadcastChannel.updateInput
    , yes

fbFormController.$inject = ['$scope', '$injector']
a.controller 'fbFormController', fbFormController


# ----------------------------------------
# fbFormObjectController
# ----------------------------------------
fbFormObjectController = ($scope, $injector) ->
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

fbFormObjectController.$inject = ['$scope', '$injector']
a.controller 'fbFormObjectController', fbFormObjectController
