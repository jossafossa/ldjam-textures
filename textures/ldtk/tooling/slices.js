const fs = require("fs");
const { exec } = require("child_process");
const fsExtra = require("fs-extra");

// detect os
const os = require("os");
const isWindows = os.platform() === "win32";
const isMac = os.platform() === "darwin";

const argv = require("minimist")(process.argv.slice(2));
console.log(argv);
const inputPath = argv.i || "./textures.ase";
const outputDir = argv.o || "./frames";
let asePath = "";
asePath = isWindows
  ? "A:/games/SteamLibrary/steamapps/common/Aseprite/Aseprite.exe"
  : asePath;
asePath = isMac
  ? "/Users/Jossafossa/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/MacOS/aseprite"
  : asePath;
asePath = argv.a || asePath;

console.log(`wathing ${inputPath}`);

const compile = () => {
  // empty output dir
  fsExtra.emptyDirSync(outputDir);

  exec(
    `"${asePath}" -b ${inputPath} --save-as ${outputDir}/{slice}.png`,
    (err, stdout, stderr) => {
      console.log(`stdout: ${stdout}`);
    }
  );
};

compile();

fs.watchFile(inputPath, (curr, prev) => {
  console.log("saved file");
  compile();
});
