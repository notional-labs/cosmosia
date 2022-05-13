import {
  ACTION_UPDATE
} from './constants';

export const actionUpdate = (name, value) => ({ type: ACTION_UPDATE, payload: {name, value} });

