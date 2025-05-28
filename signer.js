
const { exec } = require('child_process');
const path = require('path');

async function signIPA(ipaPath, p12Path, mpPath) {
  const outputPath = path.join(__dirname, 'uploads', `signed-${Date.now()}.ipa`);
  const cmd = `npx applesign -i "${ipaPath}" -c "${p12Path}" -m "${mpPath}" -o "${outputPath}" -p your_password`;

  return new Promise((resolve, reject) => {
    exec(cmd, (error, stdout, stderr) => {
      if (error) return reject(stderr);
      resolve(outputPath);
    });
  });
}

module.exports = { signIPA };
