import { useSession } from "next-auth/react";
import { listSnapshots } from '/src/helper/docker_api';
import { Dropdown, Table } from 'antd';
import { DownOutlined, GlobalOutlined } from "@ant-design/icons";
import Link from 'next/link';
import { timeAgoFormat } from "../helper/utils";

export async function getServerSideProps() {
  let snapList = [];
  try {
    snapList = await listSnapshots();
  } catch (err) {
    // do nothing
  }

  return {props: {snapList}};
}

const SnapshotTable = (props) => {
  const {data} = props;

  const dataSrc = [];
  for (const item of data) {
    const {Name} = item;
    dataSrc.push({key: Name, ...item});
  }

  return (
    <Table
      columns={[
        {
          title: 'Name',
          dataIndex: 'Name',
          key: 'Name',
          render: (text) => <>{text}</>,
          sorter: (a, b) => {
            return (a.Name < b.Name) ? -1 : (a.Name > b.Name) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'CreatedAt',
          dataIndex: 'CreatedAt',
          key: 'CreatedAt',
          render: (text) => <>{timeAgoFormat(text)}</>,
          sorter: (a, b) => {
            return (a.CreatedAt < b.CreatedAt) ? -1 : (a.CreatedAt > b.CreatedAt) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'Download',
          dataIndex: 'public_link',
          key: 'public_link',
          render: (_, { Name }) => {
            const chain_name = Name.slice(9); // remove snapshot_ prefix
            return (
              <a href={`https://snapshot.notional.ventures/${chain_name}/`} target="_blank" rel="noopener noreferrer"><GlobalOutlined /></a>
            )
          },
        },
        {
          title: 'Action',
          dataIndex: 'operation',
          key: 'operation',
          render: (_, {Name}) => {
            const chain_name = Name.slice(9); // remove snapshot_ prefix
            return (
              <Dropdown
                menu={{
                  items: [
                    {
                      key: 'snapshot_redeploy',
                      label: (
                        <Link href={`/snap_deploy?chain=${chain_name}`}>ReDeploy</Link>
                      ),
                    },
                  ],
                }}
              >
                <a onClick={(e) => e.preventDefault()}>More <DownOutlined/></a>
              </Dropdown>
            )
          },
        },
      ]}
      dataSource={dataSrc}
      pagination={false}
    />
  );
}


export default function Snapshots({snapList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="Snapshots">
      <h3>Snapshots</h3>

      <SnapshotTable data={snapList}/>
    </div>
  )
}
