import {
  ACTION_UPDATE,
  ACTION_LOAD_JSON
} from './constants';

export const actionUpdate = (name, value) => ({ type: ACTION_UPDATE, payload: {name, value} });
export const actionLoadJson = () => ({ type: ACTION_LOAD_JSON, payload: {} });
