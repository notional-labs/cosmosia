import produce from 'immer';
import { ACTION_UPDATE } from "./constants";

export const initialState = {
  snapshot_sizes: []
};

const snapshotsReducer = (state = initialState, action) =>
  produce(state, draft => {
    switch (action.type) {
      case ACTION_UPDATE:
        draft[ action.payload.name ] = action.payload.value;
        break;
      default:
        break;
    }
  });

export default snapshotsReducer;
