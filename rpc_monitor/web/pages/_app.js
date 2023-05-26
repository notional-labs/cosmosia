import '../styles/global.css';
import { SessionProvider } from "next-auth/react"
import { ConfigProvider } from 'antd';
import MainLayout from '../components/main_layout';
import { App as AntdApp } from 'antd';

export default function App({Component, pageProps: {session, ...pageProps}}) {
    return (
        <SessionProvider session={session}>
          <ConfigProvider>
            <AntdApp>
              <MainLayout>
                <Component {...pageProps} />
              </MainLayout>
            </AntdApp>
          </ConfigProvider>
        </SessionProvider>
    );
}
