'use strict'

angular.module 'clublootApp'
.factory 'Auth', ($location, $rootScope, $http, User, $cookieStore, $q) ->
  currentUser = {}
  getUser = () ->
    token = $cookieStore.get 'token'
    $.ajax(
      method: 'GET'
      url: "#{window.apiLink}/v2/user/profile.json?token=#{token}"
      ).done (data) ->
        console.log "---------------Getuser000000000-----------=============="
        currentUser = data.data
        $rootScope.user = data.data
        $rootScope.$apply()
        # deferred.resolve data.data

  if $cookieStore.get 'token'
    getUser()


  ###
  Authenticate user and save token

  @param  {Object}   user     - login info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  login: (user, callback) ->
    deferred = $q.defer()
    $http.post '/auth/local',
      email: user.email
      password: user.password

    .success (data) ->
      $cookieStore.put 'token', data.token
      currentUser = User.get()
      deferred.resolve data
      callback?()

    .error (err) =>
      @logout()
      deferred.reject err
      callback? err

    deferred.promise


  ###
  Delete access token and user info

  @param  {Function}
  ###
  logout: ->
    $cookieStore.remove 'token'
    currentUser = {}
    return


  ###
  Create a new user

  @param  {Object}   user     - user info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  createUser: (user, callback) ->
    User.save user,
      (data) ->
        $cookieStore.put 'token', data.token
        currentUser = User.get()
        callback? user

      , (err) =>
        @logout()
        callback? err

    .$promise


  ###
  Change password

  @param  {String}   oldPassword
  @param  {String}   newPassword
  @param  {Function} callback    - optional
  @return {Promise}
  ###
  changePassword: (oldPassword, newPassword, callback) ->
    User.changePassword
      id: currentUser._id
    ,
      oldPassword: oldPassword
      newPassword: newPassword

    , (user) ->
      callback? user

    , (err) ->
      callback? err

    .$promise


  ###
  Gets all available info on authenticated user

  @return {Object} user
  ###
  getCurrentUser: ->
    $rootScope.user


  signin: (user, callback) ->
    deferred = undefined
    deferred = $q.defer()
    console.log user
    console.log window.apiLink



    $.ajax
      url: "#{window.apiLink}/v2/auth/sign_in.json"
      type: 'POST'
      datatype: 'json'
      data:
        email: user.email
        password: user.password
      success: (data) ->
        console.log data
        console.log data.token
        unless data.token
          console.log "kkk"
          swal("No email in system")
          return
        $cookieStore.put 'token', data.token
        getUser()
        console.log $cookieStore.get 'token'
        return window.location.href = "/"
        deferred.resolve data
        if typeof callback == 'function' then callback() else undefined
      error: (data) ->
        swal("Password not correct")

  signinFirst: (user, callback) ->
    deferred = undefined
    deferred = $q.defer()
    console.log user
    console.log window.apiLink



    $.ajax
      url: "#{window.apiLink}/v2/auth/sign_in.json"
      type: 'POST'
      datatype: 'json'
      data:
        email: user.email
        password: user.password
      success: (data) ->
        console.log data
        console.log data.token
        unless data.token
          console.log "kkk"
          swal("No email in system")
          return
        $cookieStore.put 'token', data.token
        getUser()
        console.log $cookieStore.get 'token'
        return window.location.href = "/contest"
        deferred.resolve data
        if typeof callback == 'function' then callback() else undefined
      error: (data) ->
        swal("Password not correct")





  ###
  Check if a user is logged in synchronously

  @return {Boolean}
  ###
  isLoggedIn: ->
    currentUser.hasOwnProperty 'email'


  ###
  Waits for currentUser to resolve before checking if user is logged in
  ###
  isLoggedInAsync: (callback) ->
    if currentUser.hasOwnProperty '$promise'
      currentUser.$promise.then ->
        callback? true
        return
      .catch ->
        callback? false
        return

    else
      callback? currentUser.hasOwnProperty 'role'

  ###
  Check if a user is an admin

  @return {Boolean}
  ###
  isAdmin: ->
    currentUser.role is 'admin'


  ###
  Get auth token
  ###
  getToken: ->
    $cookieStore.get 'token'
