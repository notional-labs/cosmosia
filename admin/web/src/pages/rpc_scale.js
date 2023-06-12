import React, { useState } from 'react';
import { useSession } from "next-auth/react";
import { Button, Form, InputNumber, Input, Spin, Alert } from "antd";

export async function getServerSideProps({query}) {
  // rpc service name and replicas
  const {id, rep} = query;

  console.log(`id=${id}, rep=${rep}`);

  return {props: {id, rep}};
}

export default function RpcScale({id, rep}) {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);

  const [responseText, setResponseText] = useState("");

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    setFormState(1);

    const apiRes = await fetch('/api/rpc_scale', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(values),
    });
    const {data: apiResText} = await apiRes.json();
    setResponseText(apiResText);

    setFormState(2);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <div className="RpcScale">
      <h3>Scale a Rpc Service</h3>

      {formState === 0 &&
      <Form
        name="basic"
        labelCol={{span: 8}}
        wrapperCol={{span: 16}}
        style={{maxWidth: 600}}
        initialValues={{rpc_service_name: id, replicas: rep}}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
      >
        <Form.Item label="Rpc Service" name="rpc_service_name"
                   rules={[{required: true, message: 'Rpc Service is required'}]}>
          <Input disabled></Input>
        </Form.Item>
        <Form.Item label="Replicas" name="replicas" rules={[{required: true, message: 'Please set replicas'}]}>
          <InputNumber min={0} max={3}/>
        </Form.Item>
        <Form.Item wrapperCol={{offset: 8, span: 16}}>
          <Button type="primary" htmlType="submit">Submit</Button>
        </Form.Item>
      </Form>
      }

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
