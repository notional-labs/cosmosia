import { useSession } from "next-auth/react";
import { listSubnodes } from '/helper/docker_api';
import { Table } from 'antd';

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
          sorter: (a, b) => {
            return (a.name < b.name) ? -1 : (a.name > b.name) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
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
