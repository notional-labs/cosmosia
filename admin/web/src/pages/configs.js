import { useSession } from "next-auth/react";
import { getDockerConfigs } from '/src/helper/docker_api';
import { Table } from 'antd';

export async function getServerSideProps() {
  let configList = [];
  try {
    configList = await getDockerConfigs();
  } catch (err) {
    // do nothing
  }

  return {props: {configList}};
}

const ConfigTable = (props) => {
  const {data} = props;

  const dataSrc = [];
  for (const item of data) {
    dataSrc.push({key: item.ID, ...item})
  }

  return (
    <Table
      columns={[
        {
          title: 'Name',
          dataIndex: 'Name',
          key: 'Name',
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


export default function Configs({configList}) {
  const {data: session, status} = useSession();

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="Configs">
      <h3>Configs</h3>

      <ConfigTable data={configList}/>
    </div>
  )
}
