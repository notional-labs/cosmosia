import { getServerSession } from "next-auth/next";
import { authOptions } from "./auth/[...nextauth]";
import { updateDockerConfig } from "../../helper/docker_api";

export default async (req, res) => {
  const session = await getServerSession(req, res, authOptions);

  if (session === null) {
    return res.send({error: "Access Denied."})
  }

  const body = req.body;
  console.log('[api/config_update.js]: body=', body);
  const {id, name, data} = body;

  try {
    await updateDockerConfig({id, name, data});
    res.status(200).json({status: "success", data: null});
  } catch (err) {
    res.status(200).json({status: "error", message: err.message});
  }
}
