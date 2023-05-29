import { useSession } from "next-auth/react";
import { listLoadBalancers } from '/helper/docker_api';
import { Table } from 'antd';

export async function getServerSideProps() {
  let lbList = [];
  try {
    lbList = await listLoadBalancers();
  } catch (err) {
    // do nothing
  }

  return {props: {lbList}};
}

const LoadBalancerTable = (props) => {
  const {data} = props;

  const dataSrc = [];
  for (const lb of data) {
    dataSrc.push({key: lb, name: lb})
  }

  return (
    <Table
      columns={[
        {
          title: 'Name',
          dataIndex: 'name',
          key: 'name',
          render: (text) => <a>{text}</a>,
        },
      ]}
      dataSource={dataSrc}
    />
  );
}


export default function LoadBalancers({lbList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="LoadBalancers">
      <h3>Load Balancers</h3>

      <LoadBalancerTable data={lbList}/>
    </div>
  )
}
