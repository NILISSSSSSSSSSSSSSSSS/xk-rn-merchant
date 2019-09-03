import * as requestApi from '../config/requestApi'
import { CalculatingStringSize } from '../config/utils';
import modelInitState from '../config/modelInitState';

/**
 * 1. 消息红点
 */
const initState = {
    settings: {
        switchFriendMsg: true,
        switchShopMsg: true,
    },
    profile: {}
}

export default {
    namespace: "my",
    state: {
        ...initState
    },
    reducers: {
        save(state, action = {}) {
            return {
                ...state,
                ...action.payload
            }
        }
    },
    effects: {
        // 获取个人资料数据
        *fetchProfile({ payload: { mUserId } }, { put, select, call }) {
            try {
                let res = yield call(requestApi.merchantPersonalDataDetail, { mUserId })
                yield put({ type: 'save', payload: { profile: res || {} } })
            } catch (error) {
                Toast.show("请求数据失败")
            }
        },
        // 更新个人资料数据
        *updateProfile({ payload: { field, value, callback } }, { put, select, call }) {
            try {
                yield call(requestApi.merchantPersonalDataUpdate, { [field]: value });
                let formData = yield select(state => state.my.profile);
                // 直接更新本地数据
                let _formData = {
                    ...formData,
                    [field]: value
                };
                if (field === "birthday") {
                    let birthday = new Date(value * 1000);
                    let today = new Date();
                    let dYear = today.getFullYear() - birthday.getFullYear();
                    let preToday = today.getMonth() > birthday.getMonth() || (today.getMonth() === birthday.getMonth() && today.getDate() >= birthday.getDate()) ? 0 : 1;
                    _formData.age = dYear - preToday;
                }
                if (field === "avatar") {
                    let user = yield select(state => state.user.user);
                    yield put({ type: 'user/save', payload: { user: { ...user, avatar: value } } })
                }
                yield put({ type: 'save', payload: { profile: _formData } })
                callback(true)
            } catch (error) {
                callback(false)
            }
        },
        // 计算缓存大小
        *fetchStorageSize({ payload }, { put, call, select }) {
            try {
                let prevData = yield select(state => state);
                console.log("prevaDDDDD", prevData);
                let prevArray = Object.keys(prevData).filter(key => !["my", "nav", "user", "application", "system"].includes(key)).map(key => prevData[key])
                let size = CalculatingStringSize(JSON.stringify(prevArray));
                yield put({ type: 'save', payload: { storageSize: size } })
            } catch (error) {
                console.log(`${errorJsName},fetchStorageSize`, error)
            }
        },
        // 恢复缓存大小
        *restoreStorage({ payload }, { put, call, select, all }) {
            try {
                let keys = Object.keys(modelInitState).filter(key => !["my", "nav", "user", "application", "system"].includes(key));
                yield all(
                    keys.map(key => put({ type: `${key}/save`, payload: modelInitState[key] }))
                )
                yield put({
                    type: 'save',
                    payload: {
                        storageSize: '0KB'
                    }
                })
            } catch (error) {
                console.log(`${errorJsName},restoreStorage`, error);
            }
        }
    }
}
