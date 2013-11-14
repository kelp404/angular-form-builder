
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
        popoverTemplate:
            """
            <form>
                <div class="form-group">
                    <label class='control-label col-md-10'>Label</label>
                    <div class="col-md-10">
                        <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                    </div>
                </div>
                <div class="form-group">
                    <label class='control-label col-md-10'>Description</label>
                    <div class="col-md-10">
                        <input type='text' ng-model="description" class='form-control'/>
                    </div>
                </div>
                <div class="form-group">
                    <label class='control-label col-md-10'>Placeholder</label>
                    <div class="col-md-10">
                        <input type='text' ng-model="placeholder" class='form-control'/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-10">
                        <label class='control-label col-md-10'>
                        <input type='checkbox' ng-model="required" />
                        Required</label>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <div class="col-md-10">
                        <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                        <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                        <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                    </div>
                </div>
            </form>
            """

config.$inject = ['$builderProvider']
a.config config
