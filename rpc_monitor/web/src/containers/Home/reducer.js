import produce from 'immer';
import { ACTION_MONITOR_START, ACTION_MONITOR_STOP, ACTION_UPDATE } from "./constants";

export const initialState = {
  monitoring: false, // running or live mode
  status: {}
};

const homeReducer = (state = initialState, action) =>
  produce(state, draft => {
    switch (action.type) {
      case ACTION_UPDATE:
        draft[ action.payload.name ] = action.payload.value;
        break;
      case ACTION_MONITOR_START:
        draft[ 'monitoring' ] = true;
        break;
      case ACTION_MONITOR_STOP:
        draft[ 'monitoring' ] = false;
        break;
      default:
        break;
    }
  });

export default homeReducer;
