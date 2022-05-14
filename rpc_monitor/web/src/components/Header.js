import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { Link, withRouter } from 'react-router-dom';
import { Menu, Layout } from 'antd';

class Header extends React.Component {
  constructor(props) {
    super(props);
  };

  render() {
    return (
      <Layout.Header style={{ position: 'fixed', zIndex: 1, width: '100%' }}>
        <div className="logo"><h3>Rpc Monitor</h3></div>
        <Menu mode="horizontal" defaultSelectedKeys={['home']}>
          <Menu.Item key="home">
            <Link to="/">RPCs</Link>
          </Menu.Item>
          <Menu.Item key="snapshots">
            <Link to="/snapshots">Snapshots</Link>
          </Menu.Item>
        </Menu>
      </Layout.Header>
    )
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    dispatch,
  };
};

const withConnect = connect(
  null,
  mapDispatchToProps,
);

export default compose(withRouter, withConnect)(Header);
