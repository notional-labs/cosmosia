import { useSession } from "next-auth/react";
import { listLoadBalancers } from '/src/helper/docker_api';
import { Table, Dropdown } from 'antd';
import { DownOutlined } from "@ant-design/icons";
import Link from 'next/link';
import { getServerSession } from "next-auth/next";
import { authOptions } from "./api/auth/[...nextauth]";

export async function getServerSideProps({ req, res }) {
  const session = await getServerSession(req, res, authOptions);
  if (session) {
    const {user} = session;
    if (user) {
      let lbList = [];
      try {
        lbList = await listLoadBalancers();
      } catch (err) {
        // do nothing
      }

      return {props: {lbList}};
    }
  }

  return {props: {}};
}

const LoadBalancerTable = (props) => {
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
            const chain_name = Name.slice(3); // remove lb_ prefix
            return (
              <Dropdown
                menu={{
                  items: [
                    {
                      key: 'lb_remove',
                      label: (<Link href={`/lb_remove?chain=${chain_name}`}>Remove</Link>),
                    },
                    {
                      key: 'lb_update',
                      label: (<Link href={`/lb_update?chain=${chain_name}`}>Update</Link>),
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
