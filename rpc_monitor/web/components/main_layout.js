import Head from 'next/head';
import Link from 'next/link';
import { Layout, Menu } from 'antd';
const {Header, Content, Footer} = Layout;
import { ShoppingOutlined, KeyOutlined } from '@ant-design/icons';

// const MainNav = () => {
//   return (
//     <Menu mode='horizontal'>
//       <Menu.Item key='apikeys' icon={<KeyOutlined/>}>
//         <Link href='/apikeys'> Api-Keys </Link>
//       </Menu.Item>
//       <Menu.Item key='points' icon={<ShoppingOutlined/>}>
//         <Link href='/points'> Points </Link>
//       </Menu.Item>
//     </Menu>
//   )
// }

export default function MainLayout({children}) {
  return (
    <Layout className="layout">
      <Head>
        <link rel="icon" href="/favicon.ico"/>
        <meta
          name="description"
          content="Rpc Monitor"
        />
        <meta
          property="og:image"
          content="test content"
        />
        <meta name="og:title" content="Rpc Monitor"/>
        <meta name="twitter:card" content="summary_large_image"/>
      </Head>

      <Header style={{background: "white"}}>
        <div style={{ float: 'left', width: '120px', height: '31px', fontSize: 'large'}}><Link href='/'>Rpc Monitor</Link></div>
        {/*<MainNav />*/}
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
