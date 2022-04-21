import _ from "lodash";
import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectAppState = state => _.get(state, 'app', initialState);

const makeSelectApp = () => createSelector(selectAppState, substate => substate);
const makeSelect = key => createSelector(selectAppState, state => _.get(state, key));

const selectRouter = state => _.get(state, 'router');

const makeSelectLocation = () => createSelector(selectRouter, routerState => _.get(routerState, 'location'));

export { makeSelectApp, makeSelect, makeSelectLocation };
