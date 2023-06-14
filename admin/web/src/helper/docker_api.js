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
import { randomString } from "./utils";

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
    const testData = [  { "service": "rpc_dummy_251", "containers": [     { "ip": "10.0.14.78", "hostname": "rpc_gravitybridge_251.1.xu4p0mrsif2bzkjqsob2ztalz.net4.", "status": "200", "data_size": "542G" } ] },
      { "service": "rpc_dig_79", "containers": [     { "ip": "10.0.14.20", "hostname": "rpc_dig_79.1.7lquno4obh4tkgxvmpxf4hbna.net4.", "status": "200", "data_size": "63G" } ] },
      { "service": "rpc_cryptoorgchain_255", "containers": [     { "ip": "10.0.15.44", "hostname": "rpc_cryptoorgchain_255.1.oqm8mvah0rvsgb4h0oim6iitj.net5.", "status": "200", "data_size": "151G" } ] },
      { "service": "rpc_umee_155", "containers": [     { "ip": "10.0.15.5", "hostname": "rpc_umee_155.1.gfsw7u2t3wn9vge7gyrwuizby.net5.", "status": "200", "data_size": "456G" } ] },
      { "service": "rpc_osmosis-archive-sub_0", "containers": [     { "ip": "10.0.16.144", "hostname": "rpc_osmosis-archive-sub_0.1.oyuw6tcvelnkgpp8c9s9l40dt.net6.", "status": "200", "data_size": "4.7T" } ] },
      { "service": "rpc_akash_199", "containers": [     { "ip": "10.0.11.14", "hostname": "rpc_akash_199.1.qkemdf3r7e3w77i28mvsfamyh.net1.", "status": "200", "data_size": "423G" } ] },
      { "service": "rpc_evmos-archive-sub1_0", "containers": [     { "ip": "10.0.14.55", "hostname": "rpc_evmos-archive-sub1_0.1.2jxrdz9vjy17y7c2ciovbw74y.net4.", "status": "200", "data_size": "3.0T" } ] },
      { "service": "rpc_quicksilver_114", "containers": [     { "ip": "10.0.13.45", "hostname": "rpc_quicksilver_114.1.p12ckaib9w05vceew8jve7a67.net3.", "status": "200", "data_size": "444G" } ] },
      { "service": "rpc_noble_1", "containers": [     { "ip": "10.0.17.16", "hostname": "rpc_noble_1.1.280d4nhb3ewxr52bbm5emkwqc.net7.", "status": "200", "data_size": "23G" } ] },
      { "service": "rpc_persistent_146", "containers": [     { "ip": "10.0.15.246", "hostname": "rpc_persistent_146.1.8qd3lz3k1lk6pi8bkzo4r04x5.net5.", "status": "200", "data_size": "195G" } ] },
      { "service": "rpc_regen_151", "containers": [     { "ip": "10.0.11.26", "hostname": "rpc_regen_151.1.xsae8aby7xojvmejwphfjyogh.net1.", "status": "200", "data_size": "152G" } ] },
      { "service": "rpc_juno-archive-sub2_0", "containers": [     { "ip": "10.0.11.72", "hostname": "rpc_juno-archive-sub2_0.1.9xz6ikhn4z7x7xag3ui1yng3k.net1.", "status": "200", "data_size": "957G" } ] },
      { "service": "rpc_axelar_128", "containers": [     { "ip": "10.0.15.222", "hostname": "rpc_axelar_128.1.yc3z2tmaj6ltitm0h7ti7i409.net5.", "status": "200", "data_size": "291G" } ] },
      { "service": "rpc_juno-archive-sub1_0", "containers": [     { "ip": "10.0.11.70", "hostname": "rpc_juno-archive-sub1_0.1.fqrxd3pxlzb4hno4wo59z6om2.net1.", "status": "200", "data_size": "1.1T" } ] },
      { "service": "rpc_cyber_181", "containers": [     { "ip": "10.0.12.12", "hostname": "rpc_cyber_181.1.zkyb2doxk6mdv4gs79zrcoy12.net2.", "status": "200", "data_size": "152G" } ] },
      { "service": "rpc_sentinel_136", "containers": [     { "ip": "10.0.11.22", "hostname": "rpc_sentinel_136.1.ykcfy96g7k8zyd0rbq451i89l.net1.", "status": "200", "data_size": "182G" } ] },
      { "service": "rpc_injective_37", "containers": [     { "ip": "10.0.16.77", "hostname": "rpc_injective_37.1.upg40lw2z2i8dq1dlo7e6rvch.net6.", "status": "200", "data_size": "412G" } ] },
      { "service": "rpc_omniflixhub_96", "containers": [     { "ip": "10.0.13.14", "hostname": "rpc_omniflixhub_96.1.pfw05weau7j1oq7nhthwsttgx.net3.", "status": "200", "data_size": "157G" } ] },
      { "service": "rpc_dig-archive_0", "containers": [     { "ip": "10.0.16.11", "hostname": "rpc_dig-archive_0.1.m1qly4tzekgjzehlqqz115pg1.net6.", "status": "200", "data_size": "981G" } ] },
      { "service": "rpc_evmos-archive-sub_0", "containers": [     { "ip": "10.0.14.61", "hostname": "rpc_evmos-archive-sub_0.1.isl03ztu6pr2akbvmligt6c5x.net4.", "status": "200", "data_size": "2.0T" } ] },
      { "service": "rpc_ixo_1", "containers": [     { "ip": "10.0.12.24", "hostname": "rpc_ixo_1.1.z4xuhdkaa0liy8m6qfp56r9e4.net2.", "status": "200", "data_size": "64G" } ] },
      { "service": "rpc_cosmoshub_241", "containers": [     { "ip": "10.0.11.102", "hostname": "rpc_cosmoshub_241.1.bo74771hc9af5qdmconq91ykc.net1.", "status": "200", "data_size": "309G" },
          { "ip": "10.0.11.103", "hostname": "rpc_cosmoshub_241.2.jbyc6bkv304o6opey458q6i6n.net1.", "status": "200", "data_size": "309G" } ] },
      { "service": "rpc_emoney_133", "containers": [     { "ip": "10.0.11.96", "hostname": "rpc_emoney_133.1.icm0468nym9btxckpxm750rlb.net1.", "status": "200", "data_size": "38G" } ] },
      { "service": "rpc_quasar_1", "containers": [     { "ip": "10.0.17.34", "hostname": "rpc_quasar_1.1.c9r1d4wwia41nugu1b7ajn8ot.net7.", "status": "200", "data_size": "40G" } ] },
      { "service": "rpc_kichain_142", "containers": [     { "ip": "10.0.12.136", "hostname": "rpc_kichain_142.1.ptlie8ss7lblaeso0ld5uf018.net2.", "status": "200", "data_size": "188G" } ] },
      { "service": "rpc_terra_243", "containers": [     { "ip": "10.0.12.36", "hostname": "rpc_terra_243.1.ujt2dexjpuv9r080igucce8l0.net2.", "status": "200", "data_size": "525G" } ] },
      { "service": "rpc_likecoin_135", "containers": [     { "ip": "10.0.12.32", "hostname": "rpc_likecoin_135.1.2s3po7a5i86gsdrsyy8354k5v.net2.", "status": "200", "data_size": "85G" } ] },
      { "service": "rpc_mars_3", "containers": [     { "ip": "10.0.16.66", "hostname": "rpc_mars_3.1.nvobrvn5elmj3gz4rpkx2wei1.net6.", "status": "200", "data_size": "120G" } ] },
      { "service": "rpc_osmosis_260", "containers": [     { "ip": "10.0.16.115", "hostname": "rpc_osmosis_260.1.0r6y7kkysrmz41m3cq33vysb3.net6.", "status": "200", "data_size": "347G" },
          { "ip": "10.0.16.120", "hostname": "rpc_osmosis_260.2.bz5stroo7ea6f6mpunozbosec.net6.", "status": "200", "data_size": "348G" },
          { "ip": "10.0.16.132", "hostname": "rpc_osmosis_260.3.qrode3e4z7sznotq5ymsqb7sb.net6.", "status": "200", "data_size": "333G" } ] },
      { "service": "rpc_kujira_268", "containers": [     { "ip": "10.0.16.119", "hostname": "rpc_kujira_268.1.s3rifcz34xh8ah5fyt92zf22o.net6.", "status": "200", "data_size": "561G" } ] },
      { "service": "rpc_chihuahua_185", "containers": [     { "ip": "10.0.13.16", "hostname": "rpc_chihuahua_185.1.840m36a44ukk8s7td3lzmleoc.net3.", "status": "200", "data_size": "228G" } ] },
      { "service": "rpc_irisnet_222", "containers": [     { "ip": "10.0.15.16", "hostname": "rpc_irisnet_222.1.i47zeztuenki3yi1feuhpvywk.net5.", "status": "200", "data_size": "362G" } ] },
      { "service": "rpc_stargaze_171", "containers": [     { "ip": "10.0.12.2", "hostname": "rpc_stargaze_171.1.r2o4k2pt25joa57klmnnm5sp2.net2.", "status": "200", "data_size": "269G" } ] }
    ];

    for (const lb of testData) {
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
 * List all all node names in swarm cluster
 * @returns {Promise<unknown>}
 */
export const listServersName = async () => {
  const servers = [];

  if (process.env.NODE_ENV === "development") {
    const data = [ "cosmosia25", "cosmosia11" ];
    servers.push(...data);
  } else {
    // production
    const url = `${WEB_CONFIG_URL}/nodes`;
    const response = await fetch(url);
    const dataJson = await response.json();

    /////

    for (const server of dataJson) {
      const {Description} = server;
      const {Hostname} = Description;
      servers.push(Hostname);
    }
  }

  return servers;
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


export const getInternalProxySecretTokens = async () => {
  let data = [];

  if (process.env.NODE_ENV === "development") {
    for (let i = 0; i < 512; i++) {
      const randomToken = randomString(16);
      data.push(randomToken);
    }
  } else {
    const url = "http://tasks.web_config/config/internal_proxy_secret_tokens.txt";
    const response = await fetch(url);
    const txt = await response.text();
    data = txt.split(/\r?\n/);
  }

  return data
}
