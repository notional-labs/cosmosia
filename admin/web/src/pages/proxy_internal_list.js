import { useSession } from "next-auth/react";
import { Table } from 'antd';
import { getChainList } from "../helper/chain_registry";
import Link from "next/link";
import { GlobalOutlined } from "@ant-design/icons";
import { getInternalProxySecretTokens } from "../helper/docker_api";

export async function getServerSideProps() {
  const secretTokens = await getInternalProxySecretTokens();
  const chainList = await getChainList();

  const endpoints = [];

  let counter = 0;
  for (let i = 0; i < chainList.length; i++) {
    const chain = chainList[i];

    const rpc = `https://rpc-${chain}-${secretTokens[counter]}-ie.internalendpoints.notional.ventures`;
    counter++;
    const api = `https://api-${chain}-${secretTokens[counter]}-ie.internalendpoints.notional.ventures`;
    counter++;
    const grpc = `grpc-${chain}-${secretTokens[counter]}-ie.internalendpoints.notional.ventures:433`;
    counter++;

    endpoints.push({
      key: chain,
      name: chain,
      rpc,
      api,
      grpc,
    });
  }

  return {props: {endpoints}};
}

const InternalEndpointTable = (props) => {
  const {data} = props;

  return (
    <Table
      columns={[
        {
          title: 'Name',
          dataIndex: 'name',
          key: 'name',
          render: (text) => <>{text}</>,
          sorter: (a, b) => {
            return (a.name < b.name) ? -1 : (a.name > b.name) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'RPC',
          dataIndex: 'rpc',
          key: 'rpc',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Api',
          dataIndex: 'api',
          key: 'api',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Grpc',
          dataIndex: 'grpc',
          key: 'grpc',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
      ]}
      dataSource={data}
      pagination={false}
    />
  );
}


export default function InternalEndpoints({endpoints}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="PublicEndpoints">
      <h3>Internal Endpoints</h3>

      <InternalEndpointTable data={endpoints}/>
    </div>
  )
}
