import { combineReducers } from 'redux';
import { connectRouter } from 'connected-react-router';

import history from './utils/history';
import appReducer from './containers/App/reducer';
// import homeReducer from './containers/Home/reducer';
// import languageProviderReducer from 'containers/LanguageProvider/reducer';

/**
 * Merges the main reducer with the router state and dynamically injected reducers
 */
export default function createReducer(injectedReducers = {}) {
  const rootReducer = combineReducers({
    app: appReducer,
    // home: homeReducer,
    // language: languageProviderReducer,
    ...injectedReducers,
  });

  // Wrap the root reducer and return a new root reducer with router state
  const mergeWithRouterState = connectRouter(history);
  return mergeWithRouterState(rootReducer);
}
