import path from 'path';
import { exec } from 'child_process';
const len = process.argv.length;
if (len < 3) {
  console.error('media files please');
  process.exit(1);
}
const mediaFiles = process.argv.slice(2);
let totalSeconds = 0;
const detailSeconds = [];
const handleMedia = (mfIndex, cb) => {
  exec(`mediainfo -f ${mediaFiles[mfIndex]} | grep -m1 Duration`, (error, stdout, stderr) => {
    if (error) {
      console.error(`exec error: ${error}`);
      return;
    }
    const seconds = Math.round((stdout.match(/\d+/)[0] || 0)/1000);
    //console.log(seconds);
    //console.log(`stderr: ${stderr}`);
    cb && cb(seconds, mfIndex);
  });
};
const handleCb = (seconds, mfIndex) => {
  detailSeconds.push(seconds);
  totalSeconds += seconds;
  if (mfIndex < mediaFiles.length - 1) {
    handleMedia(++mfIndex, handleCb);
  } else {
    console.log(`总时长：${getDuration(totalSeconds)}`);
    detailSeconds.forEach((ss, i) => {
      console.log(`${path.basename(mediaFiles[i])}：${getDuration(ss)}`);
    })
  }
};
const getDuration = (seconds) => {
  const s = seconds % 60,
    m = Math.floor(seconds / 60) % 60,
    h = Math.floor(seconds / (60 * 60));
  return `${h ? `${h}时` : ''}${m ? `${m}分` : ''}${s}秒`;
};
handleMedia(0, handleCb);
