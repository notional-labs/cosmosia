import { getServerSession } from "next-auth/next";
import { authOptions } from "./auth/[...nextauth]";
import { execute_bash } from '/src/helper/bash';

export default async (req, res) => {
  const session = await getServerSession(req, res, authOptions);

  if (session === null) {
    return res.send({error: "Access Denied."})
  }

  const body = req.body;
  console.log('[api/config_update.js]: body=', body);
  const {id, name, data} = body;

  try {
    const {stdout, stderr} = await execute_bash(`docker node update --label-add ${label} ${swarm_node}`);
    res.status(200).json({status: "success", data: stdout});
  } catch ({error, stdout, stderr}) {
    res.status(200).json({status: "error", message: error, data: stdout});
  }
}
