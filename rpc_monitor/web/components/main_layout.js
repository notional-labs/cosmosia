import Head from 'next/head';
import Link from 'next/link';
import { Layout } from 'antd';
const {Header, Content, Footer} = Layout;

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
