

import { CHANGE_STATEDATA } from '../action/actionTypes'

const initialState = {
    data: [],
}

export default (state = initialState, action) => {
    switch (action.type) {
        case CHANGE_STATEDATA:
            return {
                data: action.data,
            }

        default:
            return state
    }
};