import { useSession } from "next-auth/react";
import { listServers } from '/helper/docker_api';
import { Table, Tag, Progress } from 'antd';
import { format2Decimal } from "/helper/utils";
import { CheckCircleOutlined } from '@ant-design/icons';

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
          width: 150,
          // render: (text) => <a>{text}</a>,
          sorter: (a, b) => {
            return (a.Hostname < b.Hostname) ? -1 : (a.Hostname > b.Hostname) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'Addr',
          dataIndex: 'Addr',
          key: 'Addr',
          width: 150,
          // render: (text) => <a>{text}</a>,
          sorter: (a, b) => {
            return (a.Addr < b.Addr) ? -1 : (a.Addr > b.Addr) ? 1 : 0;
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'State',
          dataIndex: 'State',
          key: 'State',
          width: 60,
          render: (text) => {
            if (text === "ready") {
              return <CheckCircleOutlined style={{color: 'green'}}/>;
            }

            return <>{text}</>
          },
        },
        {
          title: 'Resource',
          dataIndex: 'resource',
          key: 'resource',
          width: 200,
          render: (resource) => {
            const {cpu_usage, ram_total, ram_usage, disk_size, disk_usage} = resource;
            let cpuUsageValue = parseFloat(cpu_usage);
            let ramUsageValue = parseFloat(ram_usage);
            let diskUsageValue = parseFloat(disk_usage);

            return (
              <>
                <small>CPU</small> <Progress percent={format2Decimal(cpuUsageValue)} size="small" />
                <small>RAM ({ram_total})</small> <Progress percent={format2Decimal(ramUsageValue)} size="small" />
                  <small>HDD ({disk_size})</small> <Progress percent={format2Decimal(diskUsageValue)} size="small" />
              </>
            );
          },
        },
        {
          title: 'Tags',
          key: 'Tags',
          dataIndex: 'Tags',
          render: (_, { Tags }) => (
            <>
              {Tags.map((tag) => <Tag key={tag}>{tag}</Tag>)}
            </>
          ),
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
