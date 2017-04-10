angular.module 'clublootApp'
.directive 'pwCheck', ->
  require: 'ngModel'
  link: (scope, elem, attrs, ctrl) ->
    firstPassword = '#' + attrs.pwCheck
    elem.add(firstPassword).on 'keyup', ->
      scope.$apply ->
        v = elem.val() == $(firstPassword).val()
        ctrl.$setValidity 'pwmatch', v
        return
      return
    return

.directive 'dobCheck', ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, element, attrs, ngModelCtrl) ->
    $ ->
      element.datepicker
        dateFormat: 'mm/dd/yy'
        onSelect: (date) ->
          scope.$apply ->
            ngModelCtrl.$setViewValue date
            return
          return
      return
    return