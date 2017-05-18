'use strict';

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

//./node_modules/.bin/babel-node src/rename.js ~/Downloads/out.mp4 '(^out.mp4$)' 're$1'
var rename = function rename(fp, reg, replacer) {
  var basename = _path2.default.basename(fp);
  var dirname = _path2.default.dirname(fp);
  if (nameReg.test(basename)) {
    _fs2.default.rename(fp, _path2.default.join(dirname, basename.replace(reg, replacer)), function (err) {
      if (err) console.log(dirname, err);
    });
  } else {
    console.log('skiped ' + basename + ' for not match pattern');
  }
};
var len = process.argv.length;
if (len < 5) {
  console.error('invalid argv length');
  process.exit(1);
}
var files = process.argv.slice(2, len - 2);
var nameReg = new RegExp(process.argv[len - 2]);
var nameReplacer = process.argv[len - 1];
files.map(function (fp, i) {
  rename(fp, nameReg, nameReplacer);
});