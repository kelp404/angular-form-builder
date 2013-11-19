describe 'builder.provider', ->
    fakeModule = null
    builderProvider = null

    beforeEach module('builder')
    beforeEach ->
        fakeModule = angular.module 'fakeModule', ['builder']
        fakeModule.config ($builderProvider) ->
            builderProvider = $builderProvider
    beforeEach module('fakeModule')


    describe '$builder.components', ->
        it 'check $builder.components is empty', inject ($builder) ->
            expect(0).toBe Object.keys($builder.components).length
