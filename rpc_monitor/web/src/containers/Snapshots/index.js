import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'redux';
import { connect } from 'react-redux';
// import { createStructuredSelector } from 'reselect';
import injectSaga from '../../utils/injectSaga';
import injectReducer from '../../utils/injectReducer';
import { makeSelectSnapshots } from './selectors';
import reducer from './reducer';
import saga from './saga';
// import { } from './actions';

import { Button, List, Badge, Divider } from 'antd';

class Index extends Component {
  componentDidMount() {
    this.props.monitorStart();
  }

  render() {
    return (
      <div className="Snapshots">
        <h1>Snapshot Size</h1>


      </div>
    );
  }
}

const mapStateToProps = makeSelectSnapshots();
const mapDispatchToProps = dispatch => ({
  monitorStart: () => dispatch(actionMonitorStart()),
  monitorStop: () => dispatch(actionMonitorStop()),
});
const withConnect = connect(mapStateToProps, mapDispatchToProps);
const withReducer = injectReducer({ key: 'snapshots', reducer });
const withSaga = injectSaga({ key: 'snapshots', saga });

export default compose(
  withRouter,
  withReducer,
  withSaga,
  withConnect
)(Index);
