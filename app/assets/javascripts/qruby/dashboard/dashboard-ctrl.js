var app = angular.module('qruby');

app.controller('DashboardCtrl', ['$scope','QRCodeService', 'Upload', function($scope, QRCodeService, Upload) {

  $scope.generateCode = function(){
    console.log($scope.codeText);
    if(angular.isUndefined($scope.codeText) || $scope.codeText == null || $scope.codeText.trim() == ""){
      $scope.errorMessage = "Please enter text";
      return
    }
    QRCodeService.generateCode({codeText: $scope.codeText},
     function(response, _headers) {
       console.log(response)
       $scope.qrcode = response.data;
     }
   );
  }

  $scope.uploadCode = function(){
        var file = $scope.file;
        console.log('file is ' );
        console.dir(file);
        if(angular.isUndefined(file)){
          $scope.errors = "Please select file";
          return
        }
        Upload.upload({
          url: '/scan_code',
          method: 'POST',
          file: file
        }).then(function mySuccess(response) {
            console.log(response);
            $scope.errors = null;
            $scope.result = response.data.result;
        }, function myError(response) {
            console.log(response);
            $scope.result = null;
            $scope.errors = response.data.errors;

        });
  }

}]);


app.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;

            element.bind('change', function(){
                scope.$apply(function(){
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
}]);
