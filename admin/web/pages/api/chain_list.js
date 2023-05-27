var request = require('request');

let chainList = [];

const read_chain_registry_ini = (url) => new Promise((resolve, reject) => {
  request(url, (error, response, data) => {
    if (error) reject(error)
    else resolve(data)
  })
});

export default async function handler(req, res) {
  if (chainList.length <= 0) {
    const data = await read_chain_registry_ini(process.env.CHAIN_REGISTRY_INI_URL);
    const lines = data.toString().split(/(?:\r\n|\r|\n)/g);
    for (const line of lines) {
      if (line.startsWith("[")) {
        const chain = line.slice(1,-1);
        chainList.push(chain);
      }
    }
  }

  res.status(200).json(chainList);
}

