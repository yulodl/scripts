//remove watermark
//ffmpeg -i wm.mp4 -i wmcover.png -vcodec h264 -acodec copy -profile:v main -tune stillimage -filter_complex 'overlay=478:0' nowm.mp4
//ffmpeg -i wm.mp4 -f lavfi -i color=c=0xECECEC:s=324x44 -vcodec h264 -acodec copy -profile:v main -tune stillimage -filter_complex 'overlay=478:0:shortest=1' color.mp4
import fs from 'fs';
import path from 'path';
import { exec, spawn } from 'child_process';
const len = process.argv.length;
if (len < 3) {
  console.error('media files please');
  process.exit(1);
}
const config = {
  percentX: 0.26,
  percentY: 0.06
};
const getSizeAndPositionX = (width, height) => {
  const coverWidth = 2 * Math.round(width * config.percentX / 2);
  const coverHeight = 2 * Math.round(height * config.percentY / 2);
  return {
    size: `${coverWidth}x${coverHeight}`,
    positionX: `${Math.round((width - coverWidth) / 2)}`
  };
};
const mediaFiles = process.argv.slice(2).filter(mf => !/-handled/.test(mf));
const handleMedia = (mfIndex) => {
  if (mfIndex == mediaFiles.length) {
    console.log('全部视频均已去水印！');
    return;
  }
  const mf = mediaFiles[mfIndex];
  const mfHandled = mf.replace(/\.mp4/, '-handled.mp4');
  let handled = false;
  try {
    fs.statSync(mfHandled);
    handled = true;
  } catch(err) {
  }
  if (handled) {
    console.log(`跳过：${mf}，无水印文件已存在`);
    handleMedia(++mfIndex);
    return;
  }
  exec(`mediainfo -f ${mf} | grep  -E '^Width.*\\d+$|^Height.*\\d+$'`, (error, stdout, stderr) => {
    if (error) {
      console.error(`exec error: ${error}`);
      return;
    }
    const matches = stdout.match(/\d+/g);
    //console.log(matches);
    if (!matches[0] || !matches[1]) {
      console.log(`读取视频宽高失败：${mf}`);
      handleMedia(++mfIndex);
      return;
    }
    const sPX = getSizeAndPositionX(matches[0], matches[1]);
    //console.log(`stderr: ${stderr}`);
    exec(`ffmpeg -loglevel quiet -i ${mf} -f lavfi -i color=c=0xECECEC:s=${sPX.size} -vcodec h264 -acodec copy -profile:v main -tune stillimage -filter_complex 'overlay=${sPX.positionX}:0:shortest=1' ${mfHandled}`, {timeout: 2*60*1000}, (error, stdout, stderr) => {
      if (error) {
        console.error(`超时请核查：${mf}`);
      } else {
        console.log(`已处理：${mf}`);
      }
      handleMedia(++mfIndex);
    });
  });
};
handleMedia(0);
