import React, { useState } from 'react';
import { Button, Form, Select, Spin, Alert, Radio } from 'antd';
import { useSession } from "next-auth/react";
import { getChainList } from '/helper/chain_registry';
import { listRpcs } from "../helper/docker_api";

const getChainOptions = async () => {
  const chainList = await getChainList();
  const chainOptions = [];
  for (const chain of chainList) {
    const opt = {value: chain, label: chain};
    chainOptions.push(opt);
  }

  return chainOptions;
}

const getRpcServiceOptions = async () => {
  const rpcServiceOptions = [];
  const rpcList = await listRpcs();
  for (const rpcService of rpcList) {
    const opt = {value: rpcService, label: rpcService};
    rpcServiceOptions.push(opt);
  }

  return rpcServiceOptions;
}

export async function getServerSideProps() {
  const chainOptions = await getChainOptions();
  const rpcServiceOptions = await getRpcServiceOptions();

  return {props: {chainOptions, rpcServiceOptions}};
}

export default function LbDeploy({chainOptions, rpcServiceOptions}) {
  const {data: session, status} = useSession();

  // formState: 0: init, 1: submitting, 2: ok, 3: failed.
  const [formState, setFormState] = useState(0);
  const [filteredRpcServiceOptions, setFilteredRpcServiceOptions] = useState(rpcServiceOptions);
  const [responseText, setResponseText] = useState("");

  const formRef = React.useRef(null);

  if (status === "unauthenticated") return <p>Access Denied.</p>

  const onFinish = async (values) => {
    // console.log(JSON.stringify(values));
    const {chain, rpc_service, lb_type} = values;
    setFormState(1);

    const apiRes = await fetch('/api/lb_deploy', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({chain, rpc_service, lb_type}),
    });
    const {data: apiResText} = await apiRes.json();

    setResponseText(apiResText);

    setFormState(2);
  };

  const onFinishFailed = (errorInfo) => {
    console.log('Failed:', errorInfo);
  };

  const handleChainChange = (value) => {
    console.log(`handleChainChange: value=${value}`);

    const newOptions = [];

    for (const item of rpcServiceOptions) {
      if (item.value.startsWith(`rpc_${value}_`)) {
        newOptions.push(item);
      }
    }

    setFilteredRpcServiceOptions(newOptions);

    formRef.current?.setFieldsValue({
      rpc_service: null,
    });
  }

  return (
    <div className="LbDeploy">
      <h3>Deploy a Load Balancer</h3>

      {formState === 0 &&
      <Form
        name="basic"
        labelCol={{span: 8}}
        wrapperCol={{span: 16}}
        style={{maxWidth: 600}}
        initialValues={{lb_type: "caddy"}}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
        ref={formRef}
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
            onChange={handleChainChange}
          />
        </Form.Item>
        <Form.Item label="Rpc Service" name="rpc_service"
                   rules={[{required: true, message: 'Please select Rpc Service'}]}>
          <Select
            showSearch
            allowClear
            style={{width: 200}}
            placeholder="Search to Select"
            optionFilterProp="children"
            filterOption={(input, option) => (option?.label ?? '').includes(input)}
            filterSort={(optionA, optionB) =>
              (optionA?.label ?? '').toLowerCase().localeCompare((optionB?.label ?? '').toLowerCase())
            }
            options={filteredRpcServiceOptions}
            disabled={filteredRpcServiceOptions.length <= 0}
            value={null}
          />
        </Form.Item>
        <Form.Item name="lb_type" label="Load-Balancer Type">
          <Radio.Group>
            <Radio value="caddy">Caddy</Radio>
            <Radio value="haproxy">HaProxy</Radio>
          </Radio.Group>
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
