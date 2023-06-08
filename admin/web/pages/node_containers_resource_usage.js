import React, { useState } from 'react';
import { listServersName } from "../helper/docker_api";
import { Button, Form, Select, Spin, Alert, Radio } from 'antd';
import { useSession } from "next-auth/react";

export const getServerSideProps = async () => {
  const srvs = await listServersName();
  const serverOptions = [];
  for (const srv of srvs) {
    const opt = {value: srv, label: srv};
    serverOptions.push(opt);
  }

  return {props: {serverOptions}};
}

export default ({serverOptions}) => {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);
  const [responseText, setResponseText] = useState("");

  const formRef = React.useRef(null);

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    // console.log(JSON.stringify(values));
    const {swarm_node} = values;
    setFormState(1);

    const apiRes = await fetch('/api/node_docker_stats', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({swarm_node}),
    });
    const {data: apiResText} = await apiRes.json();

    setResponseText(apiResText);

    setFormState(2);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <div className="ServerDockerStats">
      <h3>Containers Resource Usage</h3>

      {/*{formState === 0 &&*/}
      <Form
        name="basic"
        labelCol={{span: 8}}
        wrapperCol={{span: 16}}
        style={{maxWidth: 600}}
        initialValues={{}}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
        ref={formRef}
      >
        <Form.Item label="Swarm node" name="swarm_node" rules={[{required: true, message: 'Please select a node'}]}>
          <Select
            showSearch
            style={{width: 200}}
            placeholder="Search to Select"
            optionFilterProp="children"
            filterOption={(input, option) => (option?.label ?? '').includes(input)}
            filterSort={(optionA, optionB) =>
              (optionA?.label ?? '').toLowerCase().localeCompare((optionB?.label ?? '').toLowerCase())
            }
            options={serverOptions}
          />
        </Form.Item>
        <Form.Item wrapperCol={{offset: 8, span: 16}}>
          <Button type="primary" htmlType="submit">Submit</Button>
        </Form.Item>
      </Form>
      {/*}*/}

      {formState === 1 &&
      <Spin tip="Loading...">
        <Alert
          message="Loading..."
          description="Your request is being executed. Please wait!"
          type="info"
        />
      </Spin>
      }

      {formState === 2 && <pre>{responseText}</pre>}

    </div>
  )
}
