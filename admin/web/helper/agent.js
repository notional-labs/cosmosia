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
