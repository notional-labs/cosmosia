import React, { useState } from 'react';
import { Button, Form, Select, Spin, Alert } from 'antd';
import { useSession } from "next-auth/react";
import { getChainList } from '/helper/chain_registry';

export async function getServerSideProps() {
  const chainList = await getChainList();

  const chainOptions = [];
  for (const chain of chainList) {
    const opt = {value: chain, label: chain};
    chainOptions.push(opt);
  }

  return {props: {chainOptions}};
}

export default function LbDeploy({chainOptions}) {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);

  const [responseText, setResponseText] = useState("");

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    const {chain} = values;
    setFormState(1);

    const apiRes = await fetch('/api/lb_deploy', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({chain}),
    });
    const {data: apiResText} = await apiRes.json();

    setResponseText(apiResText);

    setFormState(2);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  return (
    <div className="LbDeploy">
      <h3>Deploy a Load Balancer</h3>

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
        <Form.Item label="Chain" name="chain" rules={[{required: true, message: 'Please select chain'}]}>
          <Select
            showSearch
            style={{width: 200}}
            placeholder="Search to Select"
            optionFilterProp="children"
            filterOption={(input, option) => (option?.label ?? '').includes(input)}
            filterSort={(optionA, optionB) =>
              (optionA?.label ?? '').toLowerCase().localeCompare((optionB?.label ?? '').toLowerCase())
            }
            options={chainOptions}
          />
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
