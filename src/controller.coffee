
a = angular.module 'builder.controller', ['builder.provider']

# ----------------------------------------
# fbBuilderController
# ----------------------------------------
fbBuilderController = ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'

fbBuilderController.$inject = ['$scope', '$injector']
a.controller 'fbBuilderController', fbBuilderController

# ----------------------------------------
# fbComponentsController
# ----------------------------------------
fbComponentsController = ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'

    # data
    $scope.groups = $builder.groups
    $scope.components = $builder.componentsArray

    # status
    $scope.status =
        activeGroup: $scope.groups[0]

    # action
    $scope.action =
        selectGroup: ($event, group) ->
            $event.preventDefault()
            $scope.status.activeGroup = group

fbComponentsController.$inject = ['$scope', '$injector']
a.controller 'fbComponentsController', fbComponentsController

# ----------------------------------------
# fbFormController
# ----------------------------------------
fbFormController = ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'

fbFormController.$inject = ['$scope', '$injector']
a.controller 'fbFormController', fbFormController
