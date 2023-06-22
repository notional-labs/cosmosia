import { useSession } from "next-auth/react";
import { listSubnodes } from '/src/helper/docker_api';
import { Dropdown, Table } from 'antd';
import { DownOutlined } from "@ant-design/icons";
import Link from 'next/link';

export async function getServerSideProps() {
  let subnodeList = [];
  try {
    subnodeList = await listSubnodes();
  } catch (err) {
    // do nothing
  }

  return {props: {subnodeList}};
}

const SubnodeTable = (props) => {
  const {data} = props;

  const dataSrc = [];
  for (const lb of data) {
    dataSrc.push({key: lb.Name, ...lb})
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
          title: 'Action',
          dataIndex: 'operation',
          key: 'operation',
          render: (_, {Name}) => {
            const chain_name = Name.slice(4); // remove sub_ prefix
            return (
              <Dropdown
                menu={{
                  items: [
                    {
                      key: 'snapshot_remove',
                      label: (
                        <Link href={`/subnode_remove?chain=${chain_name}`}>Remove</Link>
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


export default function Subnodes({subnodeList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="Subnodes">
      <h3>Subnodes</h3>

      <SubnodeTable data={subnodeList}/>
    </div>
  )
}
