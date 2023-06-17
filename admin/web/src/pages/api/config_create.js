import { getServerSession } from "next-auth/next";
import { authOptions } from "./auth/[...nextauth]";
import { createDockerConfig } from "../../helper/docker_api";

export default async (req, res) => {
  const session = await getServerSession(req, res, authOptions);

  if (session === null) {
    return res.send({error: "Access Denied."})
  }

  const body = req.body;
  console.log('[api/config_update.js]: body=', body);
  const {name, data} = body;

  try {
    const apiRes = await createDockerConfig({name, data});
    res.status(200).json({status: "success", data: apiRes});
  } catch (err) {
    res.status(200).json({status: "error", message: err.message});
  }
}
