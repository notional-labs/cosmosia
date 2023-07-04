import { getServerSession } from "next-auth/next";
import { authOptions } from "./auth/[...nextauth]";
import fetch from "node-fetch";

export default async (req, res) => {
  const session = await getServerSession(req, res, authOptions);

  if (session === null) {
    return res.send({error: "Access Denied."})
  }

  const body = req.body;
  console.log('body: ', body);
  const {chain, rpc_service} = body;

  try {
    const url = `http://tasks.lb_${chain}/api_upstream?rpc_service_name=${rpc_service}`;
    const response = await fetch(url);
    const data = await response.text();
    res.status(200).json({status: "success", data: data});
  } catch (err) {
    res.status(200).json({status: "error", message: err.message, data: null});
  }


}

