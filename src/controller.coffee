
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
# fbFormController
# ----------------------------------------
fbFormController = ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'

fbFormController.$inject = ['$scope', '$injector']
a.controller 'fbFormController', fbFormController
