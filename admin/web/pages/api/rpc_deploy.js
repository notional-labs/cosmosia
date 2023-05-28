import { getServerSession } from "next-auth/next";
import { authOptions } from "./auth/[...nextauth]";
const { exec } = require('child_process');

const execute_bash = async (cmd) => new Promise((resolve, reject) => {
  exec(cmd, (error, stdout, stderr) => {
    if (error !== null) {
      reject({error, stdout, stderr})
    } else {
      resolve({stdout, stderr})
    }
  });
});

export default async (req, res) => {
  const session = await getServerSession(req, res, authOptions);

  if (session === null) {
    return res.send({error: "Access Denied.",})
  }

  const body = req.body;
  console.log('body: ', body);
  const { chain } = body;

  try {
    const {stdout, stderr} = await execute_bash(`sh ../rpc/docker_service_create.sh ${chain}`);
    res.status(200).json({status: "success", data: stdout});
  } catch({error, stdout, stderr}) {
    res.status(200).json({status: "error", message: error, data: stdout});
  }
}

