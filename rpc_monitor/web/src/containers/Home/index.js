import _ from "lodash";
import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'redux';
import { connect } from 'react-redux';
// import { createStructuredSelector } from 'reselect';
import injectSaga from '../../utils/injectSaga';
import injectReducer from '../../utils/injectReducer';
import { makeSelectHome } from './selectors';
import reducer from './reducer';
import saga from './saga';
import { actionMonitorStart, actionMonitorStop } from './actions';

import { Button, List, Badge } from 'antd';

const Service = (props) => {
  const {service, containers} = props;

  return (
    <div style={{paddingBottom: "10px"}}>
      <List
        header={<b>{service}</b>}
        bordered
        dataSource={containers}
        renderItem={ (item) => {
          const bgColor = item.status == 200 ? "" : "red";
          return (
            <List.Item style={{background: bgColor}}>
              {item.ip}: <Badge>{item.status}</Badge>
            </List.Item>
          )}
        }
      />
    </div>
  );
};

const Services = (props) => {
  const {services} = props;

  return (
    <div>
      {services.map((service, idx) => {
        return (
          <Service key={`service_${idx}`} {...service} />
        )
      })}
    </div>
  );
};


class Index extends Component {
  componentDidMount() {
    this.props.monitorStart();
  }

  render() {
    return (
      <div className="Home">
        <h1>Rpc Status</h1>

        <div>
          {this.props.monitoring ? (
            <Button type="primary" onClick={() => this.props.monitorStop()}>Pause</Button>
          ) : (
            <Button type="primary" onClick={() => this.props.monitorStart()}>Resume</Button>
          )}
        </div>

        <hr />

        <Services services={this.props.status} />
      </div>
    );
  }
}

const mapStateToProps = makeSelectHome();
const mapDispatchToProps = dispatch => ({
  monitorStart: () => dispatch(actionMonitorStart()),
  monitorStop: () => dispatch(actionMonitorStop()),
});
const withConnect = connect(mapStateToProps, mapDispatchToProps);
const withReducer = injectReducer({ key: 'home', reducer });
const withSaga = injectSaga({ key: 'home', saga });

export default compose(
  withRouter,
  withReducer,
  withSaga,
  withConnect
)(Index);
