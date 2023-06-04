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
import { getHostResourceUsage } from "./agent";
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
  let data = [];
  const snapshotList = [];

  if (process.env.NODE_ENV === "development") {
    data = [
      {
        "ID": "06mlazh6zx0tyhq26jni3xaho",
        "Version": {
          "Index": 1429785
        },
        "CreatedAt": "2023-05-25T18:22:57.281089623Z",
        "UpdatedAt": "2023-05-29T21:09:37.798676973Z",
        "Spec": {
          "Name": "snapshot_dig",
          "Labels": {
            "cosmosia.service": "snapshot"
          },
          "TaskTemplate": {
            "ContainerSpec": {
              "Image": "archlinux:latest@sha256:275fb964508b7a2812f43a4dfa2cfa27cb06a4a453d72675270e2222b43f2a82",
              "Args": [
                "/bin/bash",
                "-c",
                "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/snapshot_run.sh > ~/snapshot_run.sh &&   /bin/bash ~/snapshot_run.sh dig"
              ],
              "Env": [
                "CHAIN_REGISTRY_INI_URL=https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/chain_registry.ini"
              ],
              "Init": false,
              "DNSConfig": {},
              "Isolation": "default"
            },
            "Resources": {
              "Limits": {},
              "Reservations": {}
            },
            "RestartPolicy": {
              "Condition": "none",
              "Delay": 5000000000,
              "MaxAttempts": 0
            },
            "Placement": {
              "Constraints": [
                "node.hostname==cosmosia20"
              ],
              "Platforms": [
                {
                  "Architecture": "amd64",
                  "OS": "linux"
                }
              ]
            },
            "Networks": [],
            "ForceUpdate": 0,
            "Runtime": "container"
          },
          "Mode": {
            "Replicated": {
              "Replicas": 1
            }
          },
          "EndpointSpec": {
            "Mode": "dnsrr"
          }
        },
        "Endpoint": {
          "Spec": {}
        }
      },
      {
        "ID": "1dyed9hgy2sbm9z0pj30mqk9t",
        "Version": {
          "Index": 1429778
        },
        "CreatedAt": "2022-09-11T20:34:03.767030113Z",
        "UpdatedAt": "2023-05-29T21:08:07.68439254Z",
        "Spec": {
          "Name": "snapshot_cerberus",
          "Labels": {
            "cosmosia.service": "snapshot"
          },
          "TaskTemplate": {
            "ContainerSpec": {
              "Image": "archlinux:latest@sha256:3b698b409dcb528682d337b872e0b463753885e8adf246dc4d1b15ea3ec3ff15",
              "Args": [
                "/bin/bash",
                "-c",
                "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/snapshot_run.sh > ~/snapshot_run.sh &&   /bin/bash ~/snapshot_run.sh cerberus"
              ],
              "Init": false,
              "Mounts": [
                {
                  "Type": "bind",
                  "Source": "/mnt/data/snapshots/cerberus",
                  "Target": "/snapshot"
                }
              ],
              "DNSConfig": {},
              "Isolation": "default"
            },
            "Resources": {
              "Limits": {},
              "Reservations": {}
            },
            "RestartPolicy": {
              "Condition": "none",
              "Delay": 5000000000,
              "MaxAttempts": 0
            },
            "Placement": {
              "Constraints": [
                "node.hostname==cosmosia7"
              ],
              "Platforms": [
                {
                  "Architecture": "amd64",
                  "OS": "linux"
                }
              ]
            },
            "Networks": [],
            "ForceUpdate": 0,
            "Runtime": "container"
          },
          "Mode": {
            "Replicated": {
              "Replicas": 1
            }
          },
          "EndpointSpec": {
            "Mode": "dnsrr"
          }
        },
        "Endpoint": {
          "Spec": {}
        }
      },
    ];
  } else { // production
    data = await dockerApiServices(`{"label":["cosmosia.service=snapshot"]}`);
  }

  for (const snap of data) {
    const {CreatedAt, Spec} = snap;
    const {Name} = Spec;
    snapshotList.push({Name, CreatedAt});
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
    data = [
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
          "Addr": "11.22.33.44"
        }
      },
      {
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
          "Addr": "55.66.77.88"
        }
      },
    ];
  } else { // production
    const url = `${WEB_CONFIG_URL}/nodes`;
    const response = await fetch(url);
    data = await response.json();
  }

  /////
  const servers = [];
  for (const server of data) {
    const {Spec, Description, Status} = server;
    const {Labels} = Spec;
    const {Hostname} = Description;
    const {State, Addr} = Status;

    const resourceUsage = await getHostResourceUsage(Hostname);

    servers.push({
      key: Hostname,
      Hostname,
      Addr, State,
      Tags: Object.keys(Labels),
      resource: resourceUsage
    });
  }

  return servers;
}


/**
 * List all subnode services
 * @returns {Promise<unknown>}
 */
export const listSubnodes = async () => {
  let data = [];

  if (process.env.NODE_ENV === "development") {
    data = [
      {
        "ID": "s5qssuzyl5kldh292eqn3prwu",
        "Version": {
          "Index": 1429828
        },
        "CreatedAt": "2023-04-07T15:58:19.827205108Z",
        "UpdatedAt": "2023-05-30T00:46:03.138776379Z",
        "Spec": {
          "Name": "sub_osmosis",
          "Labels": {
            "cosmosia.service": "subnode"
          },
          "TaskTemplate": {
            "ContainerSpec": {
              "Image": "archlinux:latest@sha256:95024c8e97d6ef47c27960263a5c314196feef40a20b1a0c3f0419920492fb0f",
              "Args": [
                "/bin/bash",
                "-c",
                "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/run.sh > ~/run.sh &&    /bin/bash ~/run.sh osmosis"
              ],
              "Init": false,
              "DNSConfig": {},
              "Isolation": "default",
              "Sysctls": {
                "net.ipv4.tcp_tw_reuse": "1"
              }
            },
            "Resources": {
              "Limits": {},
              "Reservations": {}
            },
            "RestartPolicy": {
              "Condition": "none",
              "Delay": 5000000000,
              "MaxAttempts": 0
            },
            "Placement": {
              "Constraints": [
                "node.hostname==cosmosia32"
              ],
              "Platforms": [
                {
                  "Architecture": "amd64",
                  "OS": "linux"
                }
              ]
            },
            "Networks": [],
            "ForceUpdate": 0,
            "Runtime": "container"
          },
          "Mode": {
            "Replicated": {
              "Replicas": 1
            }
          },
          "EndpointSpec": {
            "Mode": "dnsrr"
          }
        },
        "PreviousSpec": {},
        "Endpoint": {
          "Spec": {}
        }
      },
      {
        "ID": "tiu1fp4p3lo6kgs0ga9zv5bs6",
        "Version": {
          "Index": 1429825
        },
        "CreatedAt": "2023-04-16T18:15:54.798090816Z",
        "UpdatedAt": "2023-05-30T00:45:39.329612997Z",
        "Spec": {
          "Name": "sub_cosmoshub",
          "Labels": {
            "cosmosia.service": "subnode"
          },
          "TaskTemplate": {
            "ContainerSpec": {
              "Image": "archlinux:latest@sha256:6199cf75da82918db13bbbeef7463e52f1f92b0533187f07632d3676276a64a0",
              "Args": [
                "/bin/bash",
                "-c",
                "curl -s https://raw.githubusercontent.com/notional-labs/cosmosia/main/subnode/run.sh > ~/run.sh &&    /bin/bash ~/run.sh cosmoshub"
              ],
              "Init": false,
              "DNSConfig": {},
              "Isolation": "default",
              "Sysctls": {
                "net.ipv4.tcp_tw_reuse": "1"
              }
            },
            "Resources": {
              "Limits": {},
              "Reservations": {}
            },
            "RestartPolicy": {
              "Condition": "none",
              "Delay": 5000000000,
              "MaxAttempts": 0
            },
            "Placement": {
              "Constraints": [
                "node.hostname==cosmosia32"
              ],
              "Platforms": [
                {
                  "Architecture": "amd64",
                  "OS": "linux"
                }
              ]
            },
            "Networks": [],
            "ForceUpdate": 0,
            "Runtime": "container"
          },
          "Mode": {
            "Replicated": {
              "Replicas": 1
            }
          },
          "EndpointSpec": {
            "Mode": "dnsrr"
          }
        },
        "PreviousSpec": {},
        "Endpoint": {
          "Spec": {}
        }
      }
    ];
  } else { // production
    data = await dockerApiServices(`{"label":["cosmosia.service=subnode"]}`);
  }

  /////
  const items = [];
  for (const service of data) {
    const {Spec} = service;
    const {Name} = Spec;
    items.push(Name);
  }

  return items;
}
