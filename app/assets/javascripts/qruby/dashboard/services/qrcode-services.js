var app = angular.module('qruby');

app.factory('QRCodeService', ['$resource', function($resource) {
  return $resource('/api/events/:id.json', { id: '@id' }, {
   generateCode: {
     method: 'GET',
     url: '/generate_code',
     params: {
       codeText: '@codeText'
     }
   }
 });

}]);
