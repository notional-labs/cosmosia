import React, { useState } from 'react';
import { useSession } from "next-auth/react";
import { Button, Form, Select, Spin, Alert, Result } from "antd";
import { getChainList } from '/src/helper/chain_registry';

export async function getServerSideProps({query}) {
  const chainList = await getChainList();

  const chainOptions = [];
  for (const chain of chainList) {
    const opt = {value: chain, label: chain};
    chainOptions.push(opt);
  }

  //////
  // chainInitialValue
  let {chain} = query;
  if (chain === undefined) {
    chain = "";
  }
  console.log(`chain=${chain}`);

  return {props: {chainOptions, chainInitialValue: chain}};
}

export default function LbRemove({chainOptions, chainInitialValue}) {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    setFormState(1);

    const {chain} = values;


    const apiRes = await fetch('/api/lb_remove', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({chain}),
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
    <div className="LbRemove">
      <h3>Remove Load-balancer</h3>

      {formState === 0 &&
      <Form
        name="basic"
        labelCol={{span: 8}}
        wrapperCol={{span: 16}}
        style={{maxWidth: 600}}
        initialValues={{chain: chainInitialValue}}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
      >
        <Form.Item label="Chain" name="chain" rules={[{required: true, message: 'Please select chain'}]}>
          <Select
            showSearch
            style={{
              width: 200,
            }}
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
