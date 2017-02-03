'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'contest',
    url: '/contest'
    templateUrl: 'app/contest/contest.html'
    controller: 'ContestCtrl'
    resolve:
      contests: ($http, $stateParams, $state) ->
        $http.get "/api/contest/program"

  .state 'contestnew',
    url: '/contest/new'
    templateUrl: 'app/contest/contest_new.html'
    controller: 'NewContestCtrl'
    resolve:
      templates: ($http, $stateParams) ->
        $http.get "/api/templates"
      questions: ($http, $stateParams) ->
        $http.get "/api/questions"
      programs: ($http, $stateParams) ->
        $http.get "/api/templates/program"

  .state 'contestshow',
    url: '/contest/:contest'
    templateUrl: 'app/contest/contest_show.html'
    controller: 'ContestShowCtrl'
    params:
      liveDashboard: false,
      viewPlayer: false
    resolve:
      templates: ($http, $stateParams) ->
        $http.get "/api/templates"
      program: ($http, $stateParams) ->
        $http.get "/api/contest/program"
      contest: ($http, $stateParams) ->
        $http.get "/api/contest/program/#{$stateParams.contest}"

  .state 'question',
    url: '/question/:contest/'
    templateUrl: 'app/contest/contest_question.html'
    controller: 'ContestQuestionCtrl'
    resolve:
      templates: ($http, $stateParams) ->
        $http.get "/api/templates"
      contest: ($http, $stateParams) ->
        $http.get "/api/contest/#{$stateParams.contest}"
