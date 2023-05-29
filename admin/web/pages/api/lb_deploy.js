import { getServerSession } from "next-auth/next";
import { authOptions } from "./auth/[...nextauth]";
import { execute_bash } from '/helper/bash';

export default async (req, res) => {
  const session = await getServerSession(req, res, authOptions);

  if (session === null) {
    return res.send({error: "Access Denied."})
  }

  const body = req.body;
  console.log('body: ', body);
  const {chain, rpc_service} = body;

  try {
    const {
      stdout,
      stderr
    } = await execute_bash(`cd /root/cosmosia/load_balancer && sh docker_service_create.sh ${chain} ${rpc_service}`);
    res.status(200).json({status: "success", data: stdout});
  } catch ({error, stdout, stderr}) {
    res.status(200).json({status: "error", message: error, data: stdout});
  }
}

