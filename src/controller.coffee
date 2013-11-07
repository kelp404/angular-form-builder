
a = angular.module 'builder.controller', ['builder.provider']

# ----------------------------------------
# FormBuilderComponentsController
# ----------------------------------------
fbComponentsController = ($scope, $injector) ->
    # providers
    $builder = $injector.get '$builder'

    groups = $builder.getComponentGroups()
    $scope.components = {}
    for group in groups
        $scope.components[group] = $builder.getComponentsByGroup group

fbComponentsController.$inject = ['$scope', '$injector']
a.controller 'fbComponentsController', fbComponentsController
