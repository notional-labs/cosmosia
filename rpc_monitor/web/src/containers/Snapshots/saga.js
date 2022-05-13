import { delay, put, select, takeLatest } from 'redux-saga/effects';
import { makeSelectSnapshots } from './selectors';
// import { } from './constants';
import { actionUpdate } from './actions';
import fetch from 'node-fetch';

export function* monitorStartTask() {
  while (true) {
    try {
      const snapshotsState = yield select(makeSelectSnapshots());
      const { monitoring } = snapshotsState;
      if (!monitoring) {
        break;
      }

      // console.log(JSON.stringify(window.location));
      /**
       * {"ancestorOrigins":{},"href":"http://localhost:3000/#/","origin":"http://localhost:3000","protocol":"http:","host":"localhost:3000","hostname":"localhost","port":"3000","pathname":"/","search":"","hash":"#/"}
       */
      const {protocol, host}  = window.location;
      const URL =  `${protocol}//${host}/snapshots.json`;

      const res =  yield fetch(URL, {compress: false});
      const res_json = yield res.json();
      console.log(`res_json=${JSON.stringify(res_json)}`);

      yield put(actionUpdate('snapshot_sizes', res_json));
    } catch (e) {
      console.log(e)
    } finally {
      yield delay(60000);
    }
  }
}

export default function* homeSaga() {
  yield takeLatest(ACTION_MONITOR_START, monitorStartTask);
}
