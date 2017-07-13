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

  .state 'contestQuiz',
    url: '/contest/:template_id/quiz?contest_name&contest_player&contest_fee'
    templateUrl: 'app/contest/contest_quiz.html'
    controller: 'ContestQuizCtrl'

  .state 'contestQuizJoin',
    url: '/contest/:contest_id/:template_id/join'
    templateUrl: 'app/contest/contest_join.html'
    controller: 'ContestJoinCtrl'

  .state 'contestQuizEdit',
    url: '/contest/:contest_id/:template_id/edit'
    templateUrl: 'app/contest/contest_edit.html'
    controller: 'ContestEditCtrl'

  .state 'programTemplate',
    url: '/contest/program'
    templateUrl: 'app/contest/program/template.html'
    controller: 'ContestTemplateCtrl'

  .state 'programTemplate.template',
    url: '/:program_id'
    templateUrl: 'app/contest/program/template_contest.html'
    controller: 'ContestTemplateShowCtrl'

  .state 'programTemplate.template.contest',
    url: '/:contest_id'
    templateUrl: 'app/contest/program/contest_show.html'
    controller: 'ContestShowCtrl'

  .state 'programTemplate.template.contest.vs',
    url: '/vs/:user_id'
    templateUrl: 'app/contest/program/contest_vs.html'
    controller: 'ContestVsCtrl'

  # .state 'contestshow',
  #   url: '/contest/:contest'
  #   templateUrl: 'app/contest/contest_show.html'
  #   controller: 'ContestShowCtrl'
  #   params:
  #     liveDashboard: false,
  #     viewPlayer: false
  #   resolve:
  #     templates: ($http, $stateParams) ->
  #       $http.get "/api/templates"
  #     program: ($http, $stateParams) ->
  #       $http.get "/api/contest/program"
  #     contest: ($http, $stateParams) ->
  #       $http.get "/api/contest/program/#{$stateParams.contest}"

  .state 'question',
    url: '/question/:contest/'
    templateUrl: 'app/contest/contest_question.html'
    controller: 'ContestQuestionCtrl'
    resolve:
      templates: ($http, $stateParams) ->
        $http.get "/api/templates"
      contest: ($http, $stateParams) ->
        $http.get "/api/contest/#{$stateParams.contest}"
