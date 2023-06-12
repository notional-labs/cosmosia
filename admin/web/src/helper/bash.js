const { exec } = require('child_process');

export const execute_bash = async (cmd) => new Promise((resolve, reject) => {
  exec(cmd, (error, stdout, stderr) => {
    if (error !== null) {
      reject({error, stdout, stderr})
    } else {
      resolve({stdout, stderr})
    }
  });
});
