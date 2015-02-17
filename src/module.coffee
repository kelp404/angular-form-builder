angular.module 'builder', ['builder.directive']
    .run ($validator) ->
        $validator.register('age', {
                invoke: 'watch'
                validator: (value) ->
                    value>18 and value<76
                error: 'Age must be between 18 and 76'
            })
        $validator.register('text', {
                invoke: 'watch'
                validator: (value, scope, element, attrs, $injector) ->
                    scope.minLength is 0 || (value.length >= scope.minLength && value.length <= scope.maxLength)
                error: 'There\'s a length restriction on this field'
            })
