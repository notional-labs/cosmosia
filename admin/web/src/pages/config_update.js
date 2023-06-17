import React, { useState } from 'react';
import { useSession } from "next-auth/react";
import { Button, Form, InputNumber, Input, Spin, Alert, Result } from "antd";
import { getDockerConfig } from "../helper/docker_api";
import { base64UrlSafeDecode } from "../helper/utils";

const { TextArea } = Input;

export async function getServerSideProps({query}) {
  const {id} = query;
  console.log(`[config_update.js]: id=${id}`);

  // get the config
  const cfg = await getDockerConfig(id);
  const {Spec} = cfg;
  const {Name, Data} = Spec;

  return {props: {id, name: Name, data: base64UrlSafeDecode(Data)}};
}

export default function ConfigUpdate({id, name, data}) {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    setFormState(1);

    const {f_id, f_name, f_data} = values;
    const bodyJson = {id: f_id, name: f_name, data: f_data};


    const apiRes = await fetch('/api/config_update', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(bodyJson),
    });
    const apiResJson = await apiRes.json();
    console.log(`apiResJson=${JSON.stringify(apiResJson)}`);

    if (apiResJson.status === "success") {
      setFormState(2);
    } else {
      setFormState(3);
    }
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <div className="ConfigUpdate">
      <h3>Update a Config</h3>

      {formState === 0 &&
      <Form
        name="basic"
        labelCol={{span: 8}}
        wrapperCol={{span: 16}}
        style={{maxWidth: 600}}
        initialValues={{f_id: id, f_name: name, f_data: data}}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
      >
        <Form.Item label="ID" name="f_id">
          <Input disabled/>
        </Form.Item>
        <Form.Item label="Name" name="f_name">
          <Input disabled/>
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
