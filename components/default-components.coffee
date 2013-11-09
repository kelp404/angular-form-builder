
a = angular.module 'builder.components', ['builder']

config = ($builderProvider) ->
    # ----------------------------------------
    # textInput
    # ----------------------------------------
    $builderProvider.registerComponent 'textInput',
        group: 'Default'
        label: 'Text Input'
        description: 'description'
        placeholder: 'placeholder'
        required: false
        template:
            """
            <div class="form-group">
                <label for="{{name+label}}" class="col-md-4 control-label">{{label}}</label>
                <div class="col-md-8">
                    <input type="text" id="{{name+label}}" class="form-control" placeholder="{{placeholder}}"/>
                    <p class='help-block'>{{description}}</p>
                </div>
            </div>
            """

config.$inject = ['$builderProvider']
a.config config
