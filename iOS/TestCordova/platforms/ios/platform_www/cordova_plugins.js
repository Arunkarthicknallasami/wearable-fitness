cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "com-manulife-core-testswiftplugin.TestSwiftPlugin",
        "file": "plugins/com-manulife-core-testswiftplugin/www/TestSwiftPlugin.js",
        "pluginId": "com-manulife-core-testswiftplugin",
        "clobbers": [
            "cordova.plugins.TestSwiftPlugin"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.3.2",
    "cordova-plugin-add-swift-support": "1.6.2",
    "com-manulife-core-testswiftplugin": "0.0.1"
};
// BOTTOM OF METADATA
});