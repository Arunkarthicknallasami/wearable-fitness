cordova.define("com-manulife-core-testswiftplugin.TestSwiftPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

exports.coolMethod = function(arg0, success, error) {
    exec(success, error, "TestSwiftPlugin", "coolMethod", [arg0]);
};

});
