import * as _ from 'underscore';
import React from 'react';
import useSWR from 'swr';
import { Button, List, Badge, Divider, Popover } from 'antd';
import { InfoCircleOutlined } from '@ant-design/icons';

const Service = (props) => {
  const {service, containers} = props;

  return (
    <div className="service" style={{paddingBottom: "10px"}}>
      <List
        header={<div><p className="service-name">{service}</p><hr /></div>}
        dataSource={containers}
        renderItem={ (item) => {
          const bgColor = item.status === "200" ? "" : (item.status === "503" ? "#FFC440" : "#D93026");
          return (
            <List.Item style={{background: bgColor}}>
              <div style={{width: "100%"}}>
                <span style={{float: "left"}}>
                  <Popover content={item.hostname}>
                    <InfoCircleOutlined />
                  </Popover>
                  {item.ip}
                </span>
                <span style={{float: "right"}}>{item.data_size}</span>
              </div>
            </List.Item>
          )}
        }
      />
    </div>
  );
};

const Services = (props) => {
  if (_.isUndefined(props)) {
    return null;
  }

  const {services} = props;

  if (_.isUndefined(services)) {
    return null;
  }

  return (
    <div className="services">
      <div className="contents">
        {services.map((service, idx) => {
          return (
            <Service key={`service_${idx}`} {...service} />
          )
        })}
      </div>
    </div>
  );
};

const fetcher = (...args) => fetch(...args).then(res => res.json());

export default function Home() {
  const { data, error, isLoading, mutate } = useSWR('/rpc_status.json', fetcher);

  return (
    <div className="Home">
      <div>
        <Divider type="vertical" />
        <span>
            <Badge status="default" text="Normal" /><Divider type="vertical" />
            <Badge status="error" text="Error" /><Divider type="vertical" />
            <Badge status="warning" text="Not-Synced" />
          </span>
      </div>

      <Services services={data} />
    </div>
  )
}
