import { useSession } from "next-auth/react";
import { getDockerConfigs } from '/src/helper/docker_api';
import { Dropdown, Table, Popover, Button } from 'antd';
import { timeAgoFormat } from "../helper/utils";
import Link from "next/link";
import { DownOutlined, EyeOutlined } from "@ant-design/icons";

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
        {
          title: 'Data',
          dataIndex: 'Data',
          key: 'Data',
          render: (text) => {
            const content = <pre style={{maxHeight: '8pc', overflowY: "scroll" }}>{text}</pre>;
            return content;
            // return (
            //   <Popover content={content} title="Data" trigger="click">
            //     <Button type="link" icon={<EyeOutlined/>}/>
            //   </Popover>
            // );
          },
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
          title: 'Action',
          dataIndex: 'operation',
          key: 'operation',
          render: (_, {ID, Version}) => {
            return (
              <Dropdown
                menu={{
                  items: [
                    {
                      key: 'config_update',
                      label: (
                        <Link href={`/config_update?id=${ID}&version=${Version}`}>Update</Link>
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
