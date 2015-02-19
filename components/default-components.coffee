angular.module 'builder.components', ['builder', 'validator.rules']

.config ['$builderProvider', ($builderProvider) ->

    # ----------------------------------------
    # static text field
    # ----------------------------------------
    $builderProvider.registerComponent 'textMessage',
        group: 'Basic'
        placeholder: 'Text Message'
        template:
            """
            <div class="form-group text-center">
                <p><b>{{placeholder}}</b></p>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Placeholder</label>
                                <input type='text' ng-model="placeholder" class='form-control'/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # email field
    # ----------------------------------------
    $builderProvider.registerComponent 'emailInput',
        group: 'Basic'
        label: 'Email Input'
        description: 'description'
        requireConfirmation: no
        required: no
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <input type="email" ng-model="email" placeholder="Email" class="form-control" id="email">
                                <input type="email" ng-if="requireConfirmation" ng-model="confirmEmail" placeholder="Confirm email" class="form-control" id="confirmEmail">
                    <p class='help-block'>{{description}}</p>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="required" />
                                    Required</label>
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="requireConfirmation" />
                                    Require Email Confirmation</label>
                            </div>
                            <div class="form-group" ng-if="validationOptions.length > 0">
                                <label class='control-label'>Validation</label>
                                <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """
    # ----------------------------------------
    # upload photo button
    # ----------------------------------------
    $builderProvider.registerComponent 'uploadPhoto',
        group: 'Advanced'
        label: 'Upload Photo'
        description: 'description'
        required: no
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <input type="file" accept="image/*" capture="camera">
                    <p class='help-block'>{{description}}</p>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="required" />
                                    Required</label>
                            </div>
                            <div class="form-group" ng-if="validationOptions.length > 0">
                                <label class='control-label'>Validation</label>
                                <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # signature pad
    # ----------------------------------------
    $builderProvider.registerComponent 'signaturePad',
        group: 'Advanced'
        label: 'Signature Pad'
        decription: 'description'
        required: no
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <signature-pad></signature-pad>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="required" />
                                    Required</label>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <div class="form-group" ng-if="validationOptions.length > 0">
                    <label class='control-label'>Validation</label>
                    <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # date picker
    # ----------------------------------------
    $builderProvider.registerComponent 'datePicker',
        group: 'Basic'
        label: 'Date Picker'
        description: 'description'
        required: no
        disableWeekends: no
        minDate: '2000-01-01'
        maxDate: '2100-01-01'
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <p class='help-block'>{{description}}</p>
                    <ui-date weekends="{{disableWeekends}}"></ui-date>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="required" />
                                    Required</label>
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="disableWeekends" />
                                    Disable Weekends</label>
                            </div>
                            <div class="form-group" ng-if="validationOptions.length > 0">
                                <label class='control-label'>Validation</label>
                                <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
                            </div>
                            <div class="row">
                                <div class="col-sm-6 form-group">
                                    <input type="text" placeholder="Min Date" ng-model="minDate" class="form-control">
                                </div>
                                <div class="col-sm-6 form-group">
                                    <input type="text" placeholder="Max Date" ng-model="maxDate" class="form-control">
                                </div>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # text input
    # ----------------------------------------
    $builderProvider.registerComponent 'textInput',
        group: 'Basic'
        label: 'Text Input'
        description: 'description'
        placeholder: 'placeholder'
        minLength: 0
        maxLength: 999
        readOnly: no
        required: no
        validationOptions: [
            {label: 'text', rule: '[text]'}
            {label: 'number', rule: '[number]'}
            {label: 'email', rule: '[email]'}
            {label: 'url', rule: '[url]'}
            {label: 'age', rule: '[age]'}
        ]
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <input type="text" ng-if="!readOnly" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" placeholder="{{placeholder}}"/>
                    <input type="text" ng-if="readOnly" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" placeholder="{{placeholder}}" disabled/>
                    <p class='help-block'>{{description}}</p>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Placeholder</label>
                                <input type='text' ng-model="placeholder" class='form-control'/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="required" />
                                    Required</label>
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="readOnly" />
                                    Read Only</label>
                            </div>
                            <div class="form-group" ng-if="validationOptions.length > 0">
                                <label class='control-label'>Validation</label>
                                <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
                            </div>
                            <div class="row" ng-show="validation==='[text]'">
                                <div class="form-group col-sm-6">
                                    <input type="text" class="form-control" ng-model="minLength" placeholder="Min Length">
                                </div>
                                <div class="form-group col-sm-6">
                                    <input type="text" class="form-control" ng-model="maxLength" placeholder="Max Length">
                                </div>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # Text area
    # ----------------------------------------
    $builderProvider.registerComponent 'textArea',
        group: 'Basic'
        label: 'Text Area'
        description: 'description'
        placeholder: 'placeholder'
        required: no
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <textarea type="text" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" rows='6' placeholder="{{placeholder}}"/>
                    <p class='help-block'>{{description}}</p>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Placeholder</label>
                                <input type='text' ng-model="placeholder" class='form-control'/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="required" />
                                    Required</label>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # checkbox
    # ----------------------------------------
    $builderProvider.registerComponent 'checkbox',
        group: 'Choice'
        label: 'Checkbox'
        description: 'description'
        placeholder: 'placeholder'
        required: no
        options: ['value one', 'value two']
        arrayToText: yes
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <input type='hidden' ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}"/>
                    <div class='checkbox' ng-repeat="item in options track by $index">
                        <label><input type='checkbox' ng-model="$parent.inputArray[$index]" value='item'/>
                            {{item}}
                        </label>
                    </div>
                    <p class='help-block'>{{description}}</p>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Options</label>
                                <textarea class="form-control" rows="3" ng-model="optionsText"/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="required" />
                                    Required
                                </label>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # radio
    # ----------------------------------------
    $builderProvider.registerComponent 'radio',
        group: 'Choice'
        label: 'Radio'
        description: 'description'
        placeholder: 'placeholder'
        required: no
        options: ['value one', 'value two']
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                <div class="col-sm-8">
                    <div class='radio' ng-repeat="item in options track by $index">
                        <label><input name='{{formName+index}}' ng-model="$parent.inputText" validator-group="{{formName}}" value='{{item}}' type='radio'/>
                            {{item}}
                        </label>
                    </div>
                    <p class='help-block'>{{description}}</p>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Options</label>
                                <textarea class="form-control" rows="3" ng-model="optionsText"/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

    # ----------------------------------------
    # select
    # ----------------------------------------
    $builderProvider.registerComponent 'select',
        group: 'Choice'
        label: 'Select'
        description: 'description'
        placeholder: 'placeholder'
        multiple: no
        options: ['value one', 'value two']
        # multiple: no
        # validationOptions: [
        #     {label: 'single select', rule: '/.*/'}
        #     {label: 'multiple select', rule: ['multiselect']}
        # ]
        template:
            """
            <div class="form-group">
                <label for="{{formName+index}}" class="col-sm-4 control-label">{{label}}</label>
                <div class="col-sm-8">
                    <select ng-hide="multiple" ng-options="value for value in options" id="{{formName+index}}" class="form-control"
                        ng-model="inputText" ng-init="inputText = options[0]"/>
                    <p class='help-block'>{{description}}</p>
                    <select ng-show="multiple" ng-options="value for value in options" id="{{formName+index}}" class="form-control"
                        ng-model="inputText" multiple ng-init="inputText = options[0]"/>
                </div>
            </div>
            """
        popoverTemplate:
            """
            <form>

                <div role="tabpanel">

                    <!-- Nav tabs -->
                    <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                        <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                        <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                        <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="properties">
                            <div class="form-group">
                                <label class='control-label'>Label</label>
                                <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Description</label>
                                <input type='text' ng-model="description" class='form-control'/>
                            </div>
                            <div class="form-group">
                                <label class='control-label'>Options</label>
                                <textarea class="form-control" rows="3" ng-model="optionsText"/>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="validations">
                            <div class="form-group" ng-if="validationOptions.length > 0">
                                <label class='control-label'>Validation</label>
                                <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type='checkbox' ng-model="multiple" />
                                    Multiple Select</label>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="logic"></div>
                    </div>
                </div>

                <hr/>
                <div class='form-group'>
                    <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                    <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                    <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                </div>
            </form>
            """

        # ----------------------------------------
        # Address field
        # ----------------------------------------
        $builderProvider.registerComponent 'addressField',
            group: 'Advanced'
            label: 'Address Field'
            description: 'description'
            required: no
            template:
                """
                <div class="form-group">
                    <label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                    <div class="col-sm-8">
                        <p class='help-block'>{{description}}</p>
                        <input type="text" ng-model="streetName" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" placeholder="Street Name"/>
                        <input type="text" ng-model="number" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" placeholder="Number"/>
                        <input type="text" ng-model="letter" id="{{formName+index}}" class="form-control" placeholder="Letter"/>
                        <input type="text" ng-model="floor" id="{{formName+index}}" class="form-control" placeholder="Floor"/>
                        <input type="text" ng-model="placeName" id="{{formName+index}}" class="form-control" placeholder="Place Name"/>
                        <input type="text" ng-model="postCode" id="{{formName+index}}" class="form-control" placeholder="Post Code"/>
                        <input type="text" ng-model="city" id="{{formName+index}}" class="form-control" placeholder="City"/>
                    </div>
                </div>
                """
            popoverTemplate:
                """
                <form>

                    <div role="tabpanel">

                        <!-- Nav tabs -->
                        <ul class="nav nav-justified" role="tablist" style="margin-left:-10px">
                            <li role="presentation" class="active"><a href="#properties" aria-controls="properties" role="tab" data-toggle="tab">Properties</a></li>
                            <li role="presentation"><a href="#validations" aria-controls="validations" role="tab" data-toggle="tab">Validations</a></li>
                            <li role="presentation"><a href="#logic" aria-controls="logic" role="tab" data-toggle="tab">Logic</a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div role="tabpanel" class="tab-pane active" id="properties">
                                <div class="form-group">
                                    <label class='control-label'>Label</label>
                                    <input type='text' ng-model="label" validator="[required]" class='form-control'/>
                                </div>
                                <div class="form-group">
                                    <label class='control-label'>Description</label>
                                    <input type='text' ng-model="description" class='form-control'/>
                                </div>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="validations">
                                <div class="checkbox">
                                    <label>
                                        <input type='checkbox' ng-model="required" />
                                        Required</label>
                                </div>
                                <div class="form-group" ng-if="validationOptions.length > 0">
                                    <label class='control-label'>Validation</label>
                                    <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
                                </div>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="logic"></div>
                        </div>

                    </div>

                    <hr/>
                    <div class='form-group'>
                        <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
                        <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
                        <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
                    </div>
                </form>
                """
]
