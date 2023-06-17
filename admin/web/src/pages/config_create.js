import React, { useState } from 'react';
import { useSession } from "next-auth/react";
import { Button, Form, InputNumber, Input, Spin, Alert, Result } from "antd";

const { TextArea } = Input;

export default function ConfigCreate() {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    setFormState(1);

    const {f_name, f_data} = values;
    const bodyJson = {name: f_name, data: f_data};


    const apiRes = await fetch('/api/config_create', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(bodyJson),
    });
    const {data: apiResText} = await apiRes.json();
    console.log(`apiResText=${JSON.stringify(apiResText)}`);
    setFormState(2);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <div className="ConfigCreate">
      <h3>Create a Config</h3>

      {formState === 0 &&
      <Form
        name="basic"
        labelCol={{span: 8}}
        wrapperCol={{span: 16}}
        style={{maxWidth: 600}}
        initialValues={{}}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
      >
        <Form.Item label="Name" name="f_name" rules={[{required: true, message: 'Name is required'}]}>
          <Input />
        </Form.Item>
        <Form.Item label="Data" name="f_data">
          <TextArea rows={8} />
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

      {formState === 2 && (
        <Result
          status="success"
          title="Your request has been executed successfully!"
        />
      )}

      {formState === 3 && (
        <Result
          status="warning"
          title="There are some problems with your request."
        />
      )}

    </div>
  )
}
