import { useSession } from "next-auth/react";
import { listServers } from '/src/helper/docker_api';
import { Table, Tag, Progress, Dropdown } from 'antd';
import { format2Decimal } from "/src/helper/utils";
import { CheckCircleOutlined, DownOutlined } from '@ant-design/icons';
import { useRouter } from 'next/router';
import Link from "next/link";

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
  const router = useRouter();
  const {data} = props;

  const tagCloseHandler = ({Hostname, tag}) => {
    router.push(`/node_label_remove?swarm_node=${Hostname}&label=${tag}`);
  };

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
          title: 'IP',
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
          title: 'CPU',
          dataIndex: 'cpu',
          key: 'cpu',
          width: 150,
          render: (_, {resource}) => {
            if (resource === null) {
              return null;
            }

            const {cpu_usage } = resource;
            const cpuUsageValue = parseFloat(cpu_usage);

            return (
              <div>
                <div className="resourceLabel">Avg</div>
                <Progress percent={format2Decimal(cpuUsageValue)} size="small"/>
              </div>
            );
          },
          sorter: (a, b) => {
            try {
              const aCPU = parseFloat(a.resource.cpu_usage);
              const bCPU = parseFloat(b.resource.cpu_usage);
              return (aCPU < bCPU) ? -1 : (aCPU > bCPU) ? 1 : 0;
            } catch (err) {
              return 0;
            }
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'RAM',
          dataIndex: 'ram',
          key: 'ram',
          width: 150,
          render: (_, {resource}) => {
            if (resource === null) {
              return null;
            }

            const {ram_total, ram_usage} = resource;
            const ramUsageValue = parseFloat(ram_usage);

            return (
              <div>
                <div className="resourceLabel">Size: {ram_total}</div>
                <Progress percent={format2Decimal(ramUsageValue)} size="small"/>
              </div>
            );
          },
          sorter: (a, b) => {
            try {
              const aRAM = parseFloat(a.resource.ram_usage);
              const bRAM = parseFloat(b.resource.ram_usage);
              return (aRAM < bRAM) ? -1 : (aRAM > bRAM) ? 1 : 0;
            } catch (err) {
              return 0;
            }
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'HDD',
          dataIndex: 'hdd',
          key: 'hdd',
          width: 150,
          render: (_, {resource}) => {
            if (resource === null) {
              return null;
            }

            const {disk_size, disk_usage} = resource;
            const diskUsageValue = parseFloat(disk_usage);

            return (
              <div>
                <div className="resourceLabel">Size: {disk_size}</div>
                <Progress percent={format2Decimal(diskUsageValue)} size="small"/>
              </div>
            );
          },
          sorter: (a, b) => {
            try {
              const aHDD = parseFloat(a.resource.disk_usage);
              const bHDD = parseFloat(b.resource.disk_usage);
              return (aHDD < bHDD) ? -1 : (aHDD > bHDD) ? 1 : 0;
            } catch (err) {
              return 0;
            }
          },
          sortDirections: ['ascend', 'descend'],
        },
        {
          title: 'Labels',
          key: 'Tags',
          dataIndex: 'Tags',
          render: (_, { Hostname, Tags }) => (
            <>
              {Tags.map((tag) => <Tag key={tag} closable onClose={(e) => {
                e.preventDefault();
                tagCloseHandler({Hostname, tag});
              }}>{tag}</Tag>)}
            </>
          ),
        },
        {
          title: 'Action',
          dataIndex: 'operation',
          key: 'operation',
          render: (_, { Hostname }) => (
            <Dropdown
              menu={{
                items: [
                  {
                    key: 'node_label_add',
                    label: (<Link href={`/node_label_add?swarm_node=${Hostname}`}>Add Label</Link>),
                  },
                  {
                    key: 'docker_stats',
                    label: (<Link href={`/node_containers_resource_usage?swarm_node=${Hostname}`}>Containers Resource Usage</Link>),
                  },
                ],
              }}
            >
              <a onClick={(e) => e.preventDefault()}>More <DownOutlined /></a>
            </Dropdown>
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
