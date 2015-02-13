angular.module 'builder', ['builder.directive']
    .run ($validator) ->
        $validator.register('age', {
                invoke: 'watch'
                validator: (value) ->
                    value>18 and value<76
                error: 'Age must be between 18 and 76'
            })
