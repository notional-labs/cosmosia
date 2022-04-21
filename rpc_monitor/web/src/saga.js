import { all, call, spawn } from 'redux-saga/effects';

const sagas = [
];

export default function* rootSaga() {
  yield all(sagas.map(saga =>
    spawn(function* () {
      while (true) {
        try {
          yield call(saga);
          break;
        } catch (e) {
          console.log(e);
        }
      }
    }))
  );
}


