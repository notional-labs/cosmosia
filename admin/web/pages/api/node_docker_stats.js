import { getServerSession } from "next-auth/next";
import { authOptions } from "./auth/[...nextauth]";
import { getContainersResourceUsage } from "../../helper/agent";

export default async (req, res) => {
  const session = await getServerSession(req, res, authOptions);

  if (session === null) {
    return res.send({error: "Access Denied."})
  }

  const body = req.body;
  console.log('body: ', body);
  const {swarm_node} = body;

  try {
    const stdout = await getContainersResourceUsage(swarm_node);
    res.status(200).json({status: "success", data: stdout});
  } catch ({error, stdout, stderr}) {
    res.status(200).json({status: "error", message: error, data: stdout});
  }
}
