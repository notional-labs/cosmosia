import * as _ from 'underscore';
import { useSession } from "next-auth/react";
import React, { useState, useEffect } from 'react';
import { List, Badge, Divider, Popover, Space} from 'antd';
import { InfoCircleOutlined } from "@ant-design/icons";

const Chain = (props) => {
  const {chain, nodes} = props;

  return (
    <div className="service">
      <List
        header={<h4 className="service-name">{chain}</h4>}
        dataSource={nodes}
        renderItem={(item) => {
          const bgColor = item.status === "200" ? "" : (item.status === "503" ? "#FFC440" : "#D93026");
          return (
            <List.Item style={{background: bgColor}}>
              <div style={{width: "100%"}}>
                <span style={{float: "left"}}>
                  <Space>
                   <Popover content={item.node}><InfoCircleOutlined/></Popover>
                    {item.node.split("_").pop()}
                  </Space>
                </span>
                <span style={{float: "right"}}>{item.data_size}</span>
              </div>
            </List.Item>
          )
        }}
      />
    </div>
  );
};

const Chains = (props) => {
  if (_.isUndefined(props)) {
    return null;
  }

  const {chains} = props;

  if (_.isUndefined(chains) || (_.isArray(chains) === false)) {
    return null;
  }

  return (
    <div className="services">
      <div className="contents">
        {chains.map((chain, idx) => {
          return (
            <Chain key={`chain_${idx}`} {...chain} />
          )
        })}
      </div>
    </div>
  );
};

export default () => {
  const {data: session, status} = useSession();
  const [data, setData] = useState({chains: []});

  useEffect(() => {
    const load_data = async () => {
      const response = await fetch(`/val_status.json`);
      const data = await response.json();
      data.sort((a, b) => {
        return (a.chain < b.chain) ? -1 : (a.chain > b.chain) ? 1 : 0;
      });

      setData(data);
    };

    load_data().catch(console.error);

    const interval = setInterval(async () => {
      await load_data()

    }, 60000);
    return () => clearInterval(interval);
  }, []);

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="Vals">
      <div>
        <Divider type="vertical"/>
        <span>
            <Badge status="default" text="Normal"/><Divider type="vertical"/>
            <Badge status="error" text="Error"/><Divider type="vertical"/>
            <Badge status="warning" text="Not-Synced"/>
          </span>
      </div>

      <Chains chains={data}/>
    </div>
  )
}
