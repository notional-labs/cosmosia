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
import { actionLoadJson } from './actions';
import { Table } from 'antd';


const SnapshotSizeList = (props) => {
  const {snapshot_sizes} = props;

  const columns = [
    {
      title: 'Service',
      dataIndex: 'service',
      key: 'service'
    },
    {
      title: 'Size in GB',
      dataIndex: 'file_size',
      key: 'file_size',
      render: (text) => {
        const size_in_bytes = Number.parseInt(text);
        const size_GB =  size_in_bytes / (1024 * 1024 * 1024);
        const formated_size_GB = (Math.round(size_GB * 100) / 100).toFixed(2);
        return (<div style={{ textAlign: "right" }}>{formated_size_GB}</div>)
      },
    },
  ];

  return (
    <Table columns={columns} dataSource={snapshot_sizes} />
  );
};


class Snapshots extends Component {
  componentDidMount() {
    const { snapshot_sizes } = this.props;
    if (snapshot_sizes === false) {
      this.props.loadJson();
    }
  }

  render() {
    const { snapshot_sizes } = this.props;

    return (
      <div className="Snapshots">
        <h1>Snapshot Size</h1>
        <SnapshotSizeList snapshot_sizes={snapshot_sizes} />
      </div>
    );
  }
}

const mapStateToProps = makeSelectSnapshots();
const mapDispatchToProps = dispatch => ({
  loadJson: () => dispatch(actionLoadJson())
});
const withConnect = connect(mapStateToProps, mapDispatchToProps);
const withReducer = injectReducer({ key: 'snapshots', reducer });
const withSaga = injectSaga({ key: 'snapshots', saga });

export default compose(
  withRouter,
  withReducer,
  withSaga,
  withConnect
)(Snapshots);
