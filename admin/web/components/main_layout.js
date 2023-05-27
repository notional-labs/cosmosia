import Head from 'next/head';
import Link from 'next/link';
import { useSession, signIn, signOut } from "next-auth/react";
import { Button, Layout, Space, Avatar } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import React from "react";
const {Header, Content, Footer} = Layout;

const SessionTest = () => {
  const {data: session} = useSession()

  if (session) {
    return (
      <>Signed in as {session.user.email} <br/> session: {JSON.stringify(session)}</>
    )
  }
  return (
    <header>
      Not signed in!
    </header>
  )
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
        <div style={{ float: 'left', width: '120px', height: '31px', fontSize: 'large'}}><Link href='/'>Cosmosia</Link></div>
        <div style={{ float: 'right'}}><HeaderLoginButtons /></div>
      </Header>

      <Content style={{padding: '0'}}>
        <div style={{ minHeight: '280px', padding: '24px' }}>
          {children}
        </div>
      </Content>

      <Footer style={{textAlign: 'center', background: 'white'}}>notional.ventures <br /><SessionTest /></Footer>
    </Layout>
  );
}
