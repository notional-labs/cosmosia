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
  const {rpc_service_name} = body;

  try {
    const {stdout, stderr} = await execute_bash(`docker service remove ${rpc_service_name}`);
    res.status(200).json({status: "success", data: stdout});
  } catch ({error, stdout, stderr}) {
    res.status(200).json({status: "error", message: error, data: stdout});
  }
}
