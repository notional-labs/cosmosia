import { useSession } from "next-auth/react";
import { Table } from 'antd';
import { getChainList } from "../helper/chain_registry";
import Link from "next/link";
import { GlobalOutlined } from "@ant-design/icons";

export async function getServerSideProps() {
  const chainList = await getChainList();

  return {props: {chainList}};
}

const PublicEndpointTable = (props) => {
  const {data} = props;

  const dataSrc = [];
  for (const chain of data) {
    dataSrc.push({key: chain, name: chain})
  }

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
          render: (_, {name}) => {
            return (<Link href={`https://rpc-${name}-ia.cosmosia.notional.ventures/`}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Api',
          dataIndex: 'api',
          key: 'api',
          width: 150,
          render: (_, {name}) => {
            return (<Link href={`https://api-${name}-ia.cosmosia.notional.ventures/`}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Grpc',
          dataIndex: 'grpc',
          key: 'grpc',
          width: 150,
          render: (_, {name}) => {
            return (<Link href={`grpc-${name}-ia.cosmosia.notional.ventures:443`}><GlobalOutlined /></Link>);
          },
        },
      ]}
      dataSource={dataSrc}
      pagination={false}
    />
  );
}


export default function PublicEndpoints({chainList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="PublicEndpoints">
      <h3>Public Endpoints</h3>

      <PublicEndpointTable data={chainList}/>
    </div>
  )
}
