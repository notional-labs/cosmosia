import fetch from "node-fetch";
import { getRandomFloat } from "./utils";

/**
 *
 * @param hostname is swarm node name; eg., cosmosia1, cosmosia2...
 * @returns {Promise<void>}
 */
export const getHostResourceUsage = async (hostname) => {
  if (process.env.NODE_ENV === "development") {
    return {
      "cpu_usage": `${getRandomFloat(0, 100, 2)}%`,
      "ram_total": "16G",
      "ram_usage": `${getRandomFloat(0, 100, 2)}%`,
      "disk_size": "1.2T",
      "disk_usage": `${getRandomFloat(0, 100, 2)}%`
    };
  }

  //////
  try {
    const url = `http://agent.${hostname}/host_resource_usage`;
    const response = await fetch(url);
    const data = await response.json();
    return data;
  } catch (err) {
    return null;
  }
}


/**
 * Run `docker stats --no-stream` on host to check containers resource usage.
 * @param hostname
 * @returns {Promise<unknown>}
 */
export const getContainersResourceUsage = async (hostname) => {
  if (process.env.NODE_ENV === "development") {
    const stats_txt = "CONTAINER ID   NAME                                                        CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS\n" +
      "9102c20087bd   rpc_quicksilver_141.1.hmmmjcfp5lclo1ry1xct3d1tv             135.90%   19.2GiB / 125.7GiB    15.27%    4.92TB / 5.37TB   2.45TB / 14.1TB   96\n" +
      "3b8d576247ea   rpc_axelar_128.1.yc3z2tmaj6ltitm0h7ti7i409                  6.21%     26.26GiB / 125.7GiB   20.89%    12.6TB / 13.3TB   16.8TB / 82.4TB   51\n";

    return stats_txt;
  }

  //////
  try {
    const url = `http://agent.${hostname}/containers_resource_usage`;
    const response = await fetch(url);
    const data = await response.text();
    return data;
  } catch (err) {
    return null;
  }
}
