
a = angular.module 'app', ['builder', 'builder.components']

a.controller 'BuilderController', ($scope, $builder) ->
    $builder.addFormGroup 'form',
        label: 'label'

    $scope.add = ->
        $builder.registerComponent 'textInput AA',
            group: 'AA'
            label: 'Text Input AA'
            description: 'description'
            placeholder: 'placeholder'
            required: false
            template:
                """
                <div class="form-group">
                    <label for="{{name+label}}" class="col-md-4 control-label">{{label}}</label>
                    <div class="col-md-8">
                        <input type="text" id="{{name+label}}" class="form-control" placeholder="{{placeholder}}"/>
                    </div>
                </div>
                """
