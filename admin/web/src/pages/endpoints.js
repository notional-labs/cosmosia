import { useSession } from "next-auth/react";
import { Table } from 'antd';
import { getChainList } from "../helper/chain_registry";
import Link from "next/link";
import { GlobalOutlined } from "@ant-design/icons";
import { getInternalProxySecretTokens } from "../helper/docker_api";
import { getServerSession } from "next-auth/next";
import { authOptions } from "./api/auth/[...nextauth]";

export async function getServerSideProps({req, res}) {
  const session = await getServerSession(req, res, authOptions);
  if (session) {
    const {user} = session;
    if (user) {
      const secretTokens = await getInternalProxySecretTokens();
      const chainList = await getChainList();

      const endpoints = [];

      let counter = 0;
      for (let i = 0; i < chainList.length; i++) {
        const chain = chainList[i];

        const domain = process.env.NEXT_PUBLIC_USE_DOMAIN_NAME;

        // public endpoints
        const public_rpc = `https://rpc-${chain}-ia.cosmosia.${domain}/`;
        const public_api = `https://api-${chain}-ia.cosmosia.${domain}/`;
        const public_grpc = `grpc-${chain}-ia.cosmosia.${domain}:433`;

        // internal endpoints
        const internal_rpc = `https://rpc-${chain}-${secretTokens[counter]}-ie.internalendpoints.${domain}`;
        counter++;
        const internal_api = `https://api-${chain}-${secretTokens[counter]}-ie.internalendpoints.${domain}`;
        counter++;
        const internal_grpc = `grpc-${chain}-${secretTokens[counter]}-ie.internalendpoints.${domain}:433`;
        counter++;

        endpoints.push({
          key: chain,
          name: chain,
          public_rpc,
          public_api,
          public_grpc,
          internal_rpc,
          internal_api,
          internal_grpc,
        });
      }

      return {props: {endpoints}};
    }
  }

  return {props: {}};
}

const EndpointTable = (props) => {
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
          title: 'Public RPC',
          dataIndex: 'public_rpc',
          key: 'public_rpc',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Public Api',
          dataIndex: 'public_api',
          key: 'public_api',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Public Grpc',
          dataIndex: 'public_grpc',
          key: 'public_grpc',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Internal RPC',
          dataIndex: 'internal_rpc',
          key: 'internal_rpc',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Internal Api',
          dataIndex: 'internal_api',
          key: 'internal_api',
          width: 150,
          render: (text) => {
            return (<Link href={text}><GlobalOutlined /></Link>);
          },
        },
        {
          title: 'Internal Grpc',
          dataIndex: 'internal_grpc',
          key: 'internal_grpc',
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


export default function Endpoints({endpoints}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="PublicEndpoints">
      <h3>Endpoints</h3>

      <EndpointTable data={endpoints}/>
    </div>
  )
}
