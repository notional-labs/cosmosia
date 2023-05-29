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
  const data = await dockerApiServices(`{"label":["cosmosia.service=rpc"]}`);
  return data;
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
