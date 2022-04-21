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

import { Button } from 'antd';

const ContainerItem = (props) => {
  const {ip, status} = props;

  return (
    <div>
      <span>{ip}: </span>
      <span>{status}</span>
    </div>
  );
};

const Service = (props) => {
  const {name, service} = props;
  const ips = _.keys(service);

  return (
    <div>
      <b>{name}</b>
      <div>
        {ips.map((ip, idx) => {
          return (
            <ContainerItem key={`container_${idx}`} ip={ip} status={service[ip]} />
          )
        })}
      </div>
    </div>
  );
};

const Services = (props) => {
  const {services} = props;
  const keys = _.keys(services);

  return (
    <div>
      {keys.map((service, idx) => {
        return (
          <Service key={`service_${idx}`} name={service} service={services[service]} />
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
