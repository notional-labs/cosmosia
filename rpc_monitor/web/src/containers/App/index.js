import React, { Component } from 'react';
import { Switch, Route, withRouter } from 'react-router-dom';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { makeSelectApp } from './selectors';
import { Layout } from 'antd';
import Header from '../../components/Header';
import Footer from '../../components/Footer';
import Home from '../../containers/Home';
import Snapshots from '../../containers/Snapshots';
import './App.css';

export class Index extends Component {
  render() {
    return (
      <div className="App">
        <Layout>
          <Header />
          <Layout.Content className="site-layout" style={{ padding: '0 50px', marginTop: 100 }}>
            <Switch>
              <Route path='/snapshots' component={Snapshots}/>
              <Route component={Home}/>
            </Switch>
          </Layout.Content>

          {/*<Footer/>*/}
        </Layout>
      </div>
    );
  }
}

const mapStateToProps = createStructuredSelector({
  app: makeSelectApp(),
});
const mapDispatchToProps = dispatch => ({});
const withConnect = connect(mapStateToProps, mapDispatchToProps);
// const withReducer = injectReducer({ key: 'app', reducer });
// const withSaga = injectSaga({ key: 'app', saga });

export default compose(
  // withReducer,
  // withSaga,
  withRouter,
  withConnect
)(Index);
