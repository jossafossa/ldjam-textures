const fs = require('fs');
const { exec } = require("child_process");
const fsExtra = require('fs-extra');

const argv = require('minimist')(process.argv.slice(2));
console.log(argv);
const inputPath = argv.i || './textures.ase';
const outputDir = argv.o || './frames';
const asePath = argv.a || 'A:/games/SteamLibrary/steamapps/common/Aseprite/Aseprite.exe';

console.log(`wathing ${inputPath}`);

const compile = () => {

  // empty output dir
  fsExtra.emptyDirSync(outputDir);
  
  exec(`${asePath} -b ${inputPath} --save-as ${outputDir}/{slice}.png`, (err, stdout, stderr) => {
    console.log(`stdout: ${stdout}`);
  })
}

compile();

fs.watchFile(inputPath, (curr, prev) => {
  console.log('saved file');
  compile();
});