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
    <div className="service" style={{paddingBottom: "10px"}} onMouseOver={handleMouseOver} onMouseOut={handleMouseOut}>
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
        header={<div><p className="service-name">{service}</p>
          <hr/>
        </div>}
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
      const data = await response.json();
      data.sort((a, b) => {
        return (a.service < b.service) ? -1 : (a.service > b.service) ? 1 : 0;
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
