'use strict';

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _child_process = require('child_process');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var len = process.argv.length;
if (len < 3) {
  console.error('media files please');
  process.exit(1);
}
var mediaFiles = process.argv.slice(2);
var totalSeconds = 0;
var detailSeconds = [];
var handleMedia = function handleMedia(mfIndex, cb) {
  (0, _child_process.exec)('mediainfo -f ' + mediaFiles[mfIndex] + ' | grep -m1 Duration', function (error, stdout, stderr) {
    if (error) {
      console.error('exec error: ' + error);
      return;
    }
    var seconds = Math.round((stdout.match(/\d+/)[0] || 0) / 1000);
    //console.log(seconds);
    //console.log(`stderr: ${stderr}`);
    cb && cb(seconds, mfIndex);
  });
};
var handleCb = function handleCb(seconds, mfIndex) {
  detailSeconds.push(seconds);
  totalSeconds += seconds;
  if (mfIndex < mediaFiles.length - 1) {
    handleMedia(++mfIndex, handleCb);
  } else {
    console.log('\u603B\u65F6\u957F\uFF1A' + getDuration(totalSeconds));
    detailSeconds.forEach(function (ss, i) {
      console.log(_path2.default.basename(mediaFiles[i]) + '\uFF1A' + getDuration(ss));
    });
  }
};
var getDuration = function getDuration(seconds) {
  var s = seconds % 60,
      m = Math.floor(seconds / 60) % 60,
      h = Math.floor(seconds / (60 * 60));
  return '' + (h ? h + '\u65F6' : '') + (m ? m + '\u5206' : '') + s + '\u79D2';
};
handleMedia(0, handleCb);