import React, { Component } from 'react';
import { Switch, Route, withRouter } from 'react-router-dom';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { makeSelectApp } from './selectors';
import Header from '../../components/Header';
import Footer from '../../components/Footer';
import Home from '../../containers/Home'
import './App.css';

export class Index extends Component {
  render() {
    return (
      <div className="App">
        <Header />
        <main className="Main" role="main">
          <Switch>
            {/*<Route path='/test' component={Test}/>*/}
            <Route component={Home}/>
          </Switch>
        </main>
        {/*<Footer/>*/}
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
