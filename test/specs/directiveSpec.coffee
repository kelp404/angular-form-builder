describe 'builder.directive', ->
    beforeEach module('builder')


    describe 'fb-components', ->
        $scope = null
        $compile = null
        $builder = null
        template = """<div fb-components></div>"""

        beforeEach inject ($rootScope, $injector) ->
            $scope = $rootScope.$new()
            $compile = $injector.get '$compile'
            $builder = $injector.get '$builder'

            $builder.registerComponent 'textInput',
                group: 'Default'
                label: 'Text Input'
                description: 'description'
                placeholder: 'placeholder'
                required: no
                template:
                    """
                    <div class="form-group">
                        <label for="{{name+index}}" class="col-md-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                        <div class="col-md-8">
                            <input type="text" ng-model="inputText" validator-required="{{required}}" id="{{name+index}}" class="form-control" placeholder="{{placeholder}}"/>
                            <p class='help-block'>{{description}}</p>
                        </div>
                    </div>
                    """
                popoverTemplate: """<form></form>"""

        it 'compile fb-components with a component', ->
            view = $compile(template) $scope
            $scope.$digest()
            expect($(view).find('>.form-horizontal').length).toBe 1
            $components = $(view).find '.fb-component'
            expect($components.length).toBe 1
            expect($components.attr('ng-repeat')).toEqual 'component in components'
            expect($components.attr('fb-component')).toEqual 'component'


    describe 'fb-component', ->
        $scope = null
        $compile = null
        $builder = null
        template = """<div fb-components></div>"""

        beforeEach inject ($rootScope, $injector) ->
            $scope = $rootScope.$new()
            $compile = $injector.get '$compile'
            $builder = $injector.get '$builder'

            $builder.registerComponent 'textInput',
                group: 'Default'
                label: 'Text Input'
                description: 'description'
                placeholder: 'placeholder'
                required: no
                template:
                    """
                    <div class="form-group">
                        <label for="{{name+index}}" class="col-md-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
                        <div class="col-md-8">
                            <input type="text" ng-model="inputText" validator-required="{{required}}" id="{{name+index}}" class="form-control" placeholder="{{placeholder}}"/>
                            <p class='help-block'>{{description}}</p>
                        </div>
                    </div>
                    """
                popoverTemplate: """<form></form>"""

        it 'compile fb-component and called `scope.copyObjectToScope()`', ->
            $compile(template) $scope
            $scope.$digest()

            expect($scope.$$childHead).toBe $scope.$$childTail
            child = $scope.$$childHead
            expect(child.$$hashKey).toBeUndefined()
            for key, value of $scope.components[0] when key isnt '$$hashKey'
                expect(child[key]).toEqual value

        it 'compile fb-component and called `$drag.draggable()`', inject ($drag) ->
            componentName = Object.keys($builder.components)[0]
            spyOn($drag, 'draggable').andCallFake ($element, object) ->
                expect($element.length).toBe 1
                expect($element.hasClass('fb-component')).toBe yes
                expect
                    mode: 'mirror'
                    defer: no
                    object:
                        componentName: componentName
                .toEqual object

            $compile(template) $scope
            $scope.$digest()
            expect($drag.draggable).toHaveBeenCalled()
