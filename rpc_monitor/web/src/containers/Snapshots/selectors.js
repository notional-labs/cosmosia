import _ from "lodash";
import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectSnapshotsState = state => _.get(state, 'snapshots', initialState);

const makeSelect = key => createSelector(selectSnapshotsState, state => _.get(state, key));

const makeSelectSnapshots = () => createSelector(selectSnapshotsState, substate => substate);
export { makeSelectSnapshots, makeSelect };
