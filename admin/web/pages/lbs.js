import { useSession } from "next-auth/react";
import { listLoadBalancers } from '/helper/docker_api';

export async function getServerSideProps() {
  let lbList = [];
  try {
    lbList = await listLoadBalancers();
  } catch(err) {
    // do nothing
  }

  return {props: {lbList}};
}

export default function LoadBalancers({lbList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="LoadBalancers">
      <h3>Load Balancers</h3>

      {JSON.stringify(lbList)}
    </div>
  )
}
