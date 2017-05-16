#!/usr/bin/env node
//./node_modules/.bin/babel-node src/rename.js ~/Downloads/out.mp4 '(^out.mp4$)' 're$1'
import fs from 'fs';
import path from 'path';
const len = process.argv.length;
if (len < 5) {
  console.error('invalid argv length');
  process.exit(1);
}
const files = process.argv.slice(2, len - 2);
const nameReg = new RegExp(process.argv[len-2]);
const nameReplacer = process.argv[len-1];
files.map((fp, i) => {
  const basename = path.basename(fp);
  const dirname = path.dirname(fp);
  if (nameReg.test(basename)) {
    fs.rename(fp, path.join(dirname, basename.replace(nameReg, nameReplacer)), (err) => {
      if (err) console.log(dirname, err);
    });
  } else {
    console.log(`skiped ${basename} for not match pattern`);
  }
});

