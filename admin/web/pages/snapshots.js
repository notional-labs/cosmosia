import { useSession } from "next-auth/react";
import { listSnapshots } from '/helper/docker_api';
import { Table } from 'antd';

export async function getServerSideProps() {
  let snapList = [];
  try {
    snapList = await listSnapshots();
  } catch(err) {
    // do nothing
  }

  return {props: {snapList}};
}

const SnapshotTable = (props) => {
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


export default function Snapshots({snapList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="Snapshots">
      <h3>Snapshots</h3>

      <SnapshotTable data={snapList} />
    </div>
  )
}
