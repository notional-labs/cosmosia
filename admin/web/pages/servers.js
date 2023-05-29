import { useSession } from "next-auth/react";
import { listServers } from '/helper/docker_api';
import { Table } from 'antd';

export async function getServerSideProps() {
  let serverList = [];
  try {
    serverList = await listServers();
  } catch (err) {
    // do nothing
  }

  return {props: {serverList}};
}

const ServerTable = (props) => {
  const {data} = props;

  return (
    <Table
      columns={[
        {
          title: 'Hostname',
          dataIndex: 'Hostname',
          key: 'Hostname',
          render: (text) => <a>{text}</a>,
          sorter: (a, b) => {
            return (a.Hostname < b.Hostname) ? -1 : (a.Hostname > b.Hostname) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'Addr',
          dataIndex: 'Addr',
          key: 'Addr',
          render: (text) => <a>{text}</a>,
          sorter: (a, b) => {
            return (a.Addr < b.Addr) ? -1 : (a.Addr > b.Addr) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'State',
          dataIndex: 'State',
          key: 'State',
          render: (text) => <a>{text}</a>,
          sorter: (a, b) => {
            return (a.State < b.State) ? -1 : (a.State > b.State) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
      ]}
      dataSource={data}
      pagination={false}
    />
  );
}


export default function Servers({serverList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="Servers">
      <h3>Servers</h3>

      <ServerTable data={serverList}/>
    </div>
  )
}
