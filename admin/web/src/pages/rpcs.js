import * as _ from 'underscore';
import { useSession } from "next-auth/react";
import React, { useState, useEffect } from 'react';
import { List, Badge, Divider, Popover, Space, Button, Tooltip } from 'antd';
import { InfoCircleOutlined, ColumnWidthOutlined, DeleteOutlined } from '@ant-design/icons';
import Link from 'next/link';

const Service = (props) => {
  const [isHovering, setIsHovering] = useState(false);
  const {service, containers} = props;

  const handleMouseOver = () => {
    setIsHovering(true);
  };

  const handleMouseOut = () => {
    setIsHovering(false);
  };

  return (
    <div className="service" onMouseOver={handleMouseOver} onMouseOut={handleMouseOut}>
      {isHovering && (
        <div className="service_buttons">
          <Space>
            <Tooltip title="Scale">
              <Link href={`/rpc_scale?id=${service}&rep=${containers.length}`}>
                <Button icon={<ColumnWidthOutlined/>}/>
              </Link>
            </Tooltip>
            <Tooltip title="Remove">
              <Link href={`/rpc_remove?id=${service}`}>
                <Button icon={<DeleteOutlined/>}/>
              </Link>
            </Tooltip>
          </Space>
        </div>
      )}

      <List
        header={<h4 className="service-name">{service}</h4>}
        dataSource={containers}
        renderItem={(item) => {
          const bgColor = item.status === "200" ? "" : (item.status === "503" ? "#FFC440" : "#D93026");
          return (
            <List.Item style={{background: bgColor}}>
              <div style={{width: "100%"}}>
                <span style={{float: "left"}}>
                  <Popover content={item.hostname}>
                    <InfoCircleOutlined/>
                  </Popover>
                  {item.ip}
                </span>
                <span style={{float: "right"}}>{item.data_size}</span>
              </div>
            </List.Item>
          )
        }
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

  if (_.isUndefined(services) || (_.isArray(services) === false)) {
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

export default () => {
  const {data: session, status} = useSession();
  const [data, setData] = useState({services: []});

  useEffect(() => {
    const load_data = async () => {
      const response = await fetch(`/rpc_status.json`);
      const dataTmp = await response.json();
      dataTmp.sort((a, b) => {
        return (a.hostname < b.hostname) ? -1 : (a.hostname > b.hostname) ? 1 : 0;
      });

      let services = {}
      for (const item of dataTmp) {
        const service_name = item.hostname.split('.')[0];
        const chain_name = service_name.split('_')[1];

        if (_.has(services, chain_name)) {
          services[chain_name]['containers'].push(item)
        } else {
          services[chain_name] = {service: chain_name, containers: [item]}
        }
      }

      let services2 = []
      Object.keys(services).forEach(key => {
        services2.push(services[key]);
      });

      setData(services2);
    };

    load_data().catch(console.error);

    const interval = setInterval(async () => {
      await load_data()

    }, 60000);
    return () => clearInterval(interval);
  }, []);

  if (status === "unauthenticated") return <p>Access Denied.</p>

  return (
    <div className="Rpcs">
      <div>
        <Divider type="vertical"/>
        <span>
            <Badge status="default" text="Normal"/><Divider type="vertical"/>
            <Badge status="error" text="Error"/><Divider type="vertical"/>
            <Badge status="warning" text="Not-Synced"/>
          </span>
      </div>

      <Services services={data}/>
    </div>
  )
}
