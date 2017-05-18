'use strict';

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _child_process = require('child_process');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var len = process.argv.length; //remove watermark
//ffmpeg -i wm.mp4 -i wmcover.png -vcodec h264 -acodec copy -profile:v main -tune stillimage -filter_complex 'overlay=478:0' nowm.mp4
//ffmpeg -i wm.mp4 -f lavfi -i color=c=0xECECEC:s=324x44 -vcodec h264 -acodec copy -profile:v main -tune stillimage -filter_complex 'overlay=478:0:shortest=1' color.mp4

if (len < 3) {
  console.error('media files please');
  process.exit(1);
}
var config = {
  percentX: 0.26,
  percentY: 0.06
};
var getSizeAndPositionX = function getSizeAndPositionX(width, height) {
  var coverWidth = 2 * Math.round(width * config.percentX / 2);
  var coverHeight = 2 * Math.round(height * config.percentY / 2);
  return {
    size: coverWidth + 'x' + coverHeight,
    positionX: '' + Math.round((width - coverWidth) / 2)
  };
};
var mediaFiles = process.argv.slice(2);
var handleMedia = function handleMedia(mfIndex) {
  if (mfIndex == mediaFiles.length) {
    console.log('全部视频均已去水印！');
    return;
  }
  var mf = mediaFiles[mfIndex];
  var mfHandled = mf.replace(/\.mp4/, '-handled.mp4');
  var handled = false;
  try {
    _fs2.default.statSync(mfHandled);
    handled = true;
  } catch (err) {}
  if (handled) {
    console.log('\u8DF3\u8FC7\uFF1A' + mf + '\uFF0C\u65E0\u6C34\u5370\u6587\u4EF6\u5DF2\u5B58\u5728');
    handleMedia(++mfIndex);
    return;
  }
  (0, _child_process.exec)('mediainfo -f ' + mf + ' | grep  -E \'^Width.*\\d+$|^Height.*\\d+$\'', function (error, stdout, stderr) {
    if (error) {
      console.error('exec error: ' + error);
      return;
    }
    var matches = stdout.match(/\d+/g);
    //console.log(matches);
    if (!matches[0] || !matches[1]) {
      console.log('\u8BFB\u53D6\u89C6\u9891\u5BBD\u9AD8\u5931\u8D25\uFF1A' + mf);
      handleMedia(++mfIndex);
      return;
    }
    var sPX = getSizeAndPositionX(matches[0], matches[1]);
    //console.log(`stderr: ${stderr}`);
    (0, _child_process.exec)('ffmpeg -i ' + mf + ' -f lavfi -i color=c=0xECECEC:s=' + sPX.size + ' -vcodec h264 -acodec copy -profile:v main -tune stillimage -filter_complex \'overlay=' + sPX.positionX + ':0:shortest=1\' ' + mfHandled, function (error, stdout, stderr) {
      if (error) {
        console.error('exec error: ' + error);
        return;
      }
      console.log('\u5DF2\u5904\u7406\uFF1A' + mf);
      handleMedia(++mfIndex);
    });
  });
};
handleMedia(0);