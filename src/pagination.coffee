angular.module 'app', ['builder', 'builder.components', 'validator.rules']

.controller 'PaginController', ['$scope', '$builder', '$validator', ($scope, $builder, $validator) ->

	$scope.pages = [$builder.forms['default'],]


]