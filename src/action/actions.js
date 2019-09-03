/**
 * actions 入口
 */

import * as totalActions from './totalActions';
import * as userActions from './userActions';
import * as shopActions from './shopActions';
import * as mallActions from './mallActions';
import * as orderActions from './orderActions';
import * as freightManageAction from './FreightManageAction'
import * as taskAction from './taskAction'
import * as systemAction from './systemAction'

import * as welfareActions from './welfareActions'
export default {
    ...totalActions,
    ...userActions,
    ...shopActions,
    ...mallActions,
    ...orderActions,
    ...freightManageAction,
    ...welfareActions,
    ...taskAction,
    ...systemAction
};
