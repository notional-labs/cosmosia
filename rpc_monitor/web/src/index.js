import React from 'react';
import ReactDOM from 'react-dom';
import {HashRouter} from 'react-router-dom';
import {Provider} from 'react-redux';
import App from './containers/App';
import configureStore from './configureStore';
import history from './utils/history';
import appSaga from './containers/App/saga';
import './style.css';

// Create redux store with history
const initialState = {};
const store = configureStore(initialState, history);

// then run the saga
store.runSaga(appSaga); // rootSaga

ReactDOM.render(
  <Provider store={store}>
    <HashRouter>
      <App/>
    </HashRouter>
  </Provider>,
  document.getElementById('root')
);
