import '../styles/global.css';
import { ConfigProvider } from 'antd';
import MainLayout from '../components/main_layout';
import { App as AntdApp } from 'antd';

export default function App({Component, pageProps: {...pageProps}}) {
  return (
    <ConfigProvider>
      <AntdApp>
        <MainLayout>
          <Component {...pageProps} />
        </MainLayout>
      </AntdApp>
    </ConfigProvider>
  );
}
