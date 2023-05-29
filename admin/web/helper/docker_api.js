/**
 *
 * using unix-socket
 *
 * list of rpcs:
 * curl -sG -XGET --unix-socket /var/run/docker.sock http://localhost/services --data-urlencode 'filters={"label":["cosmosia.service=rpc"]}' |jq -r '.[].Spec.Name'
 *
 * list of lbs:
 * curl -sG -XGET --unix-socket /var/run/docker.sock http://localhost/services --data-urlencode 'filters={"label":["cosmosia.service=lb"]}' |jq -r '.[].Spec.Name'
 *
 *
 * however, its not able to use unix-socket with node-fetch, so we'll use `web_config` instead (`https://github.com/notional-labs/cosmosia/blob/main/web_config/run.sh#L71`)
 * curl -sG -XGET http://tasks.web_config:2375/services --data-urlencode 'filters={"label":["cosmosia.service=rpc"]}' |jq -r '.[].Spec.Name'
 */

import fetch from 'node-fetch';
const { readFileSync } = require('fs');

const WEB_CONFIG_URL = "http://tasks.web_config:2375";

/**
 * request to http://tasks.web_config:2375/services
 * @param filter example: {"label":["cosmosia.service=rpc"]}
 */
export const dockerApiServices = async (filter) => {
  const url = `${WEB_CONFIG_URL}/services?filters=${encodeURIComponent(filter)}`;
  console.log(`dockerApiServices: url=${url}`);
  const response = await fetch(url);
  const data = await response.json();
  return data;
}

/**********************************************************************************************************************/

export const listRpcs = async () => {
  const rpcList = [];

  if (process.env.NODE_ENV === "development") {
    const txt = readFileSync('./public/rpc_status.json');
    const data = JSON.parse(txt);

    for (const lb of data) {
      const {service} = lb;
      rpcList.push(service);
    }
  } else { // production
    const data = await dockerApiServices(`{"label":["cosmosia.service=rpc"]}`);
    for (const lb of data) {
      const {Spec} = lb;
      const {Name} = Spec;
      rpcList.push(Name);
    }
  }

  return rpcList;
}

export const listLoadBalancers = async () => {
  const loadBalancerList = [];

  const data = await dockerApiServices(`{"label":["cosmosia.service=lb"]}`);
  for (const lb of data) {
    const {Spec} = lb;
    const {Name} = Spec;
    loadBalancerList.push(Name);
  }
  return loadBalancerList;
}

export const listSnapshots = async () => {
  const snapshotList = [];

  if (process.env.NODE_ENV === "development") {
    // put some dummy data here
    snapshotList.push(`snapshot_starname`);
    snapshotList.push(`snapshot_osmosis-testnet`);
    snapshotList.push(`snapshot_quasar`);
  } else { // production
    const data = await dockerApiServices(`{"label":["cosmosia.service=snapshot"]}`);
    for (const snap of data) {
      const {Spec} = snap;
      const {Name} = Spec;
      snapshotList.push(Name);
    }
  }

  return snapshotList;
}

/**
 * List all all nodes in swarm cluster
 * @returns {Promise<unknown>}
 */
export const listServers = async () => {
  let data = [];

  if (process.env.NODE_ENV === "development") {
    data = [{
      "ID": "wrm8uee8vqrhkgb0047y870py",
      "CreatedAt": "2022-09-10T21:31:32.567026483Z",
      "UpdatedAt": "2023-05-26T08:53:22.499157797Z",
      "Spec": {
        "Labels": {
          "cosmosia.archive": "true",
          "cosmosia.rpc.dig-archive": "true",
          "cosmosia.rpc.evmos-archive": "true",
          "cosmosia.rpc.juno-archive-sub1": "true",
          "cosmosia.rpc.juno-archive-sub2": "true"
        },
        "Role": "worker",
        "Availability": "active"
      },
      "Description": {
        "Hostname": "cosmosia11",
        "Platform": {
          "Architecture": "x86_64",
          "OS": "linux"
        },
        "Resources": {
          "NanoCPUs": 32000000000,
          "MemoryBytes": 134996893696
        },
        "Engine": {
          "EngineVersion": "20.10.18",
          "Plugins": []
        },
        "TLSInfo": {}
      },
      "Status": {
        "State": "ready",
        "Addr": "65.108.237.230"
      }
    },
      {
        "ID": "ypvfybi5brl1rtbqwbtjpcibr",
        "CreatedAt": "2023-01-22T11:06:06.265746447Z",
        "UpdatedAt": "2023-05-14T00:04:30.599166202Z",
        "Spec": {
          "Labels": {
            "cosmosia.rpc.whitewhale": "true"
          },
          "Role": "worker",
          "Availability": "active"
        },
        "Description": {
          "Hostname": "cosmosia25",
          "Platform": {
            "Architecture": "x86_64",
            "OS": "linux"
          },
          "Resources": {
            "NanoCPUs": 32000000000,
            "MemoryBytes": 134994927616
          },
          "Engine": {
            "EngineVersion": "20.10.23",
            "Plugins": []
          },
          "TLSInfo": {}
        },
        "Status": {
          "State": "ready",
          "Addr": "65.109.34.161"
        }
      }];
  } else { // production
    const url = `${WEB_CONFIG_URL}/nodes`;
    const response = await fetch(url);
    data = await response.json();
  }

  /////
  const servers = [];
  for (const server of data) {
    const {Description, Status} = server;
    const {Hostname} = Description;
    const {State, Addr} = Status;

    servers.push({Hostname, Addr, State});
  }

  return servers;
}
