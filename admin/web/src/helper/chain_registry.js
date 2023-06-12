var request = require('request');

let chainList = []; // to cache result

const read_chain_registry_ini = (url) => new Promise((resolve, reject) => {
  request(url, (error, response, data) => {
    if (error) reject(error)
    else resolve(data)
  })
});

export const getChainList = async () => {
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

  return chainList;
}

////////////////////////////////////////////////////////////////////////////////
// subnode_registry
// https://github.com/notional-labs/cosmosia/blob/main/data/subnode_registry.ini

export const getSubnodeList = async () => {
  // need update to make it dynamic, use static for now
  const lst = ["osmosis", "juno", "cosmoshub", "evmos"];

  return lst;
}
