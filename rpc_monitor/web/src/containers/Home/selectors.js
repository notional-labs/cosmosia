import _ from "lodash";
import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectHomeState = state => _.get(state, 'home', initialState);

const makeSelect = key => createSelector(selectHomeState, state => _.get(state, key));

const makeSelectHome = () => createSelector(selectHomeState, substate => substate);
export { makeSelectHome, makeSelect };
