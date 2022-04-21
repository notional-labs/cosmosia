import {
  ACTION_UPDATE,
  ACTION_MONITOR_START,
  ACTION_MONITOR_STOP
} from './constants';

export const actionUpdate = (name, value) => ({ type: ACTION_UPDATE, payload: {name, value} });
export const actionMonitorStart = () => ({ type: ACTION_MONITOR_START, payload: {} });
export const actionMonitorStop = () => ({ type: ACTION_MONITOR_STOP, payload: {} });
