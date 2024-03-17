import Head from 'next/head';
import Link from 'next/link';
import { useSession, signIn, signOut } from "next-auth/react";
import { Button, Layout, Space, Avatar, Menu } from 'antd';
import {
  DesktopOutlined,
  UserOutlined,
  CloudServerOutlined,
  PlusCircleOutlined,
  PartitionOutlined,
  FileSyncOutlined,
  FileOutlined,
  ClusterOutlined,
  DatabaseOutlined,
  ApiOutlined,
  GlobalOutlined,
  SettingOutlined,
  EditOutlined
} from '@ant-design/icons';
import React from "react";
const {Header, Content, Footer} = Layout;

const MainNav = () => {
  const {data: session} = useSession()
  if (session) {
    return (
      <Menu mode='horizontal'>
        <Menu.SubMenu key='rpcs' title="Rpcs" icon={<CloudServerOutlined />}>
          <Menu.Item key='rpc_monitor' icon={<DesktopOutlined />}>
            <Link href='/rpcs'>Monitor</Link>
          </Menu.Item>
          <Menu.Item key='rpc_deploy' icon={<PlusCircleOutlined />}>
            <Link href='/rpc_deploy'>Deploy</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='vals' title="Vals" icon={<CloudServerOutlined />}>
          <Menu.Item key='val_monitor' icon={<DesktopOutlined />}>
            <Link href='/vals'>Monitor</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='lbs' title="Load Balancers" icon={<CloudServerOutlined />}>
          <Menu.Item key='lb_list' icon={<PartitionOutlined />}>
            <Link href='/lbs'>List</Link>
          </Menu.Item>
          <Menu.Item key='lb_deploy' icon={<PlusCircleOutlined />}>
            <Link href='/lb_deploy'>Deploy</Link>
          </Menu.Item>
          <Menu.Item key='lb_update' icon={<EditOutlined />}>
            <Link href='/lb_update'>Update</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='snapshots' title="Snapshots" icon={<FileSyncOutlined />}>
          <Menu.Item key='snap_list' icon={<FileOutlined />}>
            <Link href='/snapshots'>List</Link>
          </Menu.Item>
          <Menu.Item key='snap_deploy' icon={<PlusCircleOutlined />}>
            <Link href='/snap_deploy'>Deploy</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='relays' title="Relays" icon={<FileSyncOutlined />}>
          <Menu.Item key='relays_refill' icon={<FileOutlined />}>
            <Link href='https://relayrefiller.notional.ventures/' rel="noopener noreferrer" target="_blank">Relay Refiller</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='servers' title="Servers" icon={<ClusterOutlined />}>
          <Menu.Item key='server_list' icon={<ClusterOutlined />}>
            <Link href='/servers'>Swarm Nodes</Link>
          </Menu.Item>
          <Menu.Item key='docker_stats' icon={<DesktopOutlined />}>
            <Link href='/node_containers_resource_usage'>Containers Resource Usage</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='subnodes' title="Subnodes" icon={<DatabaseOutlined />}>
          <Menu.Item key='subnode_list' icon={<DatabaseOutlined />}>
            <Link href='/subnodes'>Subnodes</Link>
          </Menu.Item>
          <Menu.Item key='sub_deploy' icon={<PlusCircleOutlined />}>
            <Link href='/subnode_deploy'>Deploy</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='proxies' title="Proxies" icon={<ApiOutlined />}>
          <Menu.Item key='endpoints' icon={<GlobalOutlined />}>
            <Link href='/endpoints'>Endpoints</Link>
          </Menu.Item>
        </Menu.SubMenu>
        <Menu.SubMenu key='configs' title="Configs" icon={<SettingOutlined />}>
          <Menu.Item key='config_list' icon={<SettingOutlined />}>
            <Link href='/configs'>List</Link>
          </Menu.Item>
          <Menu.Item key='config_create' icon={<PlusCircleOutlined />}>
            <Link href='/config_create'>Create Config</Link>
          </Menu.Item>
        </Menu.SubMenu>
      </Menu>
    )
  }
  return (null)
}

const HeaderLoginButtons = () => {
  const {data: session} = useSession()
  if (session) {
    return (
      <Space wrap>
        <div><Avatar icon={<UserOutlined />} /> {session.user.name}</div>
        <Button onClick={() => signOut()}>Logout</Button>
      </Space>
    )
  }

  return (<Space wrap><Button onClick={() => signIn()}>Login</Button></Space>)
}

export default function MainLayout({children}) {
  return (
    <Layout className="layout">
      <Head>
        <link rel="icon" href="/favicon.ico"/>
        <meta
          name="description"
          content="Cosmosia"
        />
        <meta
          property="og:image"
          content="test content"
        />
        <meta name="og:title" content="Cosmosia"/>
        <meta name="twitter:card" content="summary_large_image"/>
      </Head>

      <Header style={{background: "white"}}>
        <div style={{ float: 'left', width: '120px', height: '31px', fontSize: 'large'}}><Link href='/' style={{ color: '#c4181a' }}>Cosmosia</Link></div>
        <div style={{ float: 'right'}}><HeaderLoginButtons /></div>
        <MainNav />
      </Header>

      <Content style={{padding: '0'}}>
        <div style={{ minHeight: '280px', padding: '24px' }}>
          {children}
        </div>
      </Content>

      <Footer style={{textAlign: 'center', background: 'white'}}>notional.ventures</Footer>
    </Layout>
  );
}
