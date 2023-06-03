import React, { useState } from 'react';
import { useSession } from "next-auth/react";
import { Button, Form, InputNumber, Input, Spin, Alert } from "antd";

export async function getServerSideProps({query}) {
  // swarm_node and label
  const {swarm_node, label} = query;

  console.log(`swarm_node=${swarm_node}, label=${label}`);

  return {props: {swarm_node, label}};
}

export default function NodeLabelRemove({swarm_node, label}) {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);

  const [responseText, setResponseText] = useState("");

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    setFormState(1);

    const {f_swarm_node, f_label} = values;
    const bodyJson = {swarm_node: f_swarm_node, label: f_label};


    const apiRes = await fetch('/api/node_label_remove', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(bodyJson),
    });
    const {data: apiResText} = await apiRes.json();
    setResponseText(apiResText);

    setFormState(2);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <div className="NodeLabelRemove">
      <h3>Remove label from Swarm Node</h3>

      {formState === 0 &&
      <Form
        name="basic"
        labelCol={{span: 8}}
        wrapperCol={{span: 16}}
        style={{maxWidth: 600}}
        initialValues={{f_swarm_node: swarm_node, f_label: label}}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
      >
        <Form.Item label="Swarm Node" name="f_swarm_node"
                   rules={[{required: true, message: 'Swarm Node is required'}]}>
          <Input disabled></Input>
        </Form.Item>
        <Form.Item label="Label to Remove" name="f_label"
                   rules={[{required: true, message: 'Label is required'}]}>
          <Input disabled></Input>
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
