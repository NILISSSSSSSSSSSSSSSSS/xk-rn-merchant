/**
 * 任务中心
 */
import * as nativeApi from '../config/nativeApi';
import * as requestApi from '../config/requestApi';
import modelInitState from '../config/modelInitState';
import * as taskRequest from '../config/taskCenterRequest';
import { TASK_CATEGORIES, MERCHANT_TYPE_MAP_NAME } from '../const/task';
import Pagination from '../services/pagination';
import * as taskServices from '../services/task';

export default {
  namespace: 'task',
  state: modelInitState.task,
  reducers: {
    save(state, action) {
      return {
        ...state,
        ...action.payload,
      };
    },
  },
  effects: {
    // 联盟商列表
    * fetchMerchantDelegate(action, { put, call, select }) {
      try {
        const data = yield call(requestApi.merchantDelegate, action.payload);
        if (data) {
          data.isSelected = false;
        }
        yield put({ type: 'save', payload: { singleMerchantList: data } });
      } catch (err) {
        Toast.show('请求失败，请重试！');
        console.log(err);
      }
    },
    // 单个委派 员工列表
    * fetchEmployeeDelegate(action, { put, call, select }) {
      const params = action.payload;
      console.log(action.payload);
      try {
        const data = yield call(requestApi.employeeDelegate, action.payload);
        console.log('单个委派 员工列表', data);
        const task = yield select(state => state.task);
        const prevDataList = task.singleAppontAccountList;
        let _data;
        if (params.page === 1) {
          _data = data ? data.data : [];
        } else {
          _data = data ? [...prevDataList.data, ...data.data] : prevDataList.data;
        }
        const _total = params.page === 1
          ? (data)
            ? data.total
            : 0
          : prevDataList.total;
        const hasMore = data ? _total !== _data.length : false;
        const initData = handleSetSelectStatue(_data);
        prevDataList.data = initData;
        prevDataList.hasMore = hasMore;
        prevDataList.page = params.page;
        prevDataList.total = _total;
        prevDataList.refreshing = false;
        // let listData = prevDataList
        yield put({ type: 'save', payload: { singleAppontAccountList: prevDataList } });
      } catch (err) {
        Toast.show('请求失败，请重试！');
        console.log(err);
      }
    },
    // 获取任务，验收，审核的分店(员工)列表
    * fetchStaffList({ payload: { type = '', params = {} } }, { put, call, select }) {
      let request = requestApi.preJobDelegatingPage;
      let preListIndex = 0; // 获取redux中已存在的委派数据列表 0 任务，1验收，2审核
      switch (type) {
        case 'task': request = requestApi.preJobDelegatingPage; preListIndex = 0; break;
        case 'check': request = requestApi.preCheckDelegatingPage; preListIndex = 1; break;
        case 'audit': request = requestApi.preAuditDelegatingPage; preListIndex = 2; break;
        default: request = requestApi.preJobDelegatingPage; preListIndex = 0; break;
      }
      try {
        const res = yield call(request, params);
        const task = yield select(state => state.task);
        console.log('员工列表', res);
        const prevDataList = task.appointList[preListIndex];
        const data = res ? res.pageable || [] : prevDataList;
        let _data;
        if (params.page === 1) {
          _data = data ? data.data : [];
        } else {
          _data = data ? [...prevDataList.data, ...data.data] : prevDataList.data;
        }
        const _total = params.page === 1
          ? (data)
            ? data.total
            : 0
          : prevDataList.total;
        const hasMore = data ? _total !== _data.length : false;
        // 设置选择的初始状态
        const initData = handleSetSelectStatue(_data);
        prevDataList.data = initData;
        prevDataList.hasMore = hasMore;
        prevDataList.page = params.page;
        prevDataList.total = _total;
        prevDataList.refreshing = false;
        // let listData = prevDataList
        const pre_list = (yield select(state => state.task)).appointList;
        pre_list[preListIndex] = prevDataList;
        yield put({ type: 'save', payload: { pre_list } });
      } catch (err) {
        Toast.show('请求失败，请重试！');
        console.log(err);
      }
    },
    // 获取任务、验收、审核预委派(已委派)列表
    * getPreAppointList({ payload: { type = '', params = { page: 1, limit: 10 } } }, { put, call, select }) {
      let request = requestApi.preJobDelegatedPage;
      let preListIndex = 0; // 获取redux中已存在的委派数据列表 0 任务，1验收，2审核
      switch (type) {
        case 'task': request = requestApi.preJobDelegatedPage; preListIndex = 0; break;
        case 'check': request = requestApi.preCheckDelegatedPage; preListIndex = 1; break;
        case 'audit': request = requestApi.preAuditDelegatedPage; preListIndex = 2; break;
        default: request = requestApi.preJobDelegatedPage; preListIndex = 0; break;
      }
      try {
        let data = yield call(request, params);
        console.log('已委派列表', data);
        const prevDataList = (yield select(state => state.task)).appointedList[preListIndex];
        let _data;
        data ? null : data = { data: [] };
        data.data ? null : data.data = [];
        if (params.page === 1) {
          _data = data ? data.data : [];
        } else {
          _data = data ? [...prevDataList.data, ...data.data] : prevDataList.data;
        }
        const _total = params.page === 1
          ? (data)
            ? data.total
            : 0
          : prevDataList.total;
        const hasMore = data ? _total !== _data.length : false;
        prevDataList.data = _data;
        prevDataList.hasMore = hasMore;
        prevDataList.page = params.page;
        prevDataList.total = _total;
        prevDataList.refreshing = false;
        // let listData = prevDataList
        const pre_list = (yield select(state => state.task)).appointedList;
        pre_list[preListIndex] = prevDataList;
        yield put({ type: 'save', payload: { appointedList: [...pre_list] } });
      } catch (err) {
        Toast.show('请求失败，请重试！');
        console.log(err);
      }
    },
    // 选择员工修改状态
    // data 传入对象修改联盟商或者分店数据 { appointList: newData }
    * updateStaffList(action, { put, call, select }) {
      yield put({ type: 'save', payload: { appointList: action.payload.appointList } });
    },
    // 更新联盟商员工选择状态
    * updateSingleAppointList(action, { put, call, select }) {
      yield put({ type: 'save', payload: action.payload });
    },
    /** 获取验收、 */
    * fetchTaskList(action, { put, call, select }) {
      const params = action.payload;
      const {
        type, formData, page, limit, isFirstLoad,
      } = params;
      const taskList = yield select(state => state.task.taskList);
      const func = type === TASK_CATEGORIES.TrainTask ? taskRequest.fetchTrainingJobQPage : taskRequest.fetchAuditJobQPage;
      const pagination = new Pagination().StartFetch(page, limit, isFirstLoad);
      if (func) {
        const { list: oldList } = taskList || {};
        yield put({
          type: 'save',
          payload: {
            taskList: {
              ...taskList,
              list: oldList,
              pagination: { ...pagination },
            },
          },
        });
        try {
          const res = yield call(func, { ...formData, page, limit });
          if (res) {
            const jobData = res.jobData || {};
            const data = jobData.data || [];
            const total = jobData.total || 0;
            const list = page === 1 ? data : oldList.concat(data);
            const statistics = res.jobNumbers;
            const merchantStatistics = res.auditJobNumbers || res.trainingJobNumbers || {};
            pagination.EndFetch(total);
            yield put({
              type: 'save',
              payload: {
                taskList: {
                  ...taskList,
                  pagination: { ...pagination },
                  list,
                  statistics,
                  merchantStatistics,
                },
              },
            });
            return;
          }
        } catch (err) { console.log(err); }
      }
      pagination.ErrorFetch();
      const list = page === 1 ? [] : oldList;
      yield put({
        type: 'save',
        payload: {
          taskList: {
            ...taskList,
            pagination: { ...pagination },
            list,
          },
        },
      });
      Toast.show('获取任务列表失败');
    },
    /** 获取任何首页统计数据 */
    * fetchMerchantNewJobPage(action, { put, call, select }) {
      try {
        const res = yield call(taskRequest.fetchMerchantNewJobPage, {});
        const taskHomeData = res.data.map(task => ({ ...task, merchantTypeName: MERCHANT_TYPE_MAP_NAME[task.merchantType] }));
        yield put({ type: 'save', payload: { taskHomeData } });
      } catch (err) {
        console.log('err', err);
        Toast.show('获取任务首页数据失败');
      }
    },
    * setJobDelegate({ payload: { callback, ...formData } }, { put, call, select }) {
      try {
        yield call(taskRequest.fetchsetJobDelegate, formData);
        callback && callback();
      } catch (err) {
        Toast.show('委派任务失败');
      }
    },

    /** 审核任务详情 */
    * fetchTaskDetail({ payload: { jobId } }, { put, call, select }) {
      try {
        const res = yield call(taskRequest.fetchEnterTaskList, { jobId });
        res.lists = [];
        if (res && res.jobs) {
          const tasks = [];
          res.jobs.forEach((item, index) => {
            if (item.step === 0) {
              res.lists[0] = [item];
            } else {
              tasks.push(item);
            }
          });
          res.lists[1] = tasks;
        }

        if (res && res.histories) {
          (res.histories || []).forEach(item=> {
            item.log = taskServices.filterLog(item);
            item.name = taskServices.filterNameByStatus(item);
          });
        }

        yield put({ type: 'save', payload: {
          taskDetail: res,
        }});
      } catch (error) {
        console.log(error);
      }
    },
    * toTaskDetailNext({ payload: item }, { put, call, select }) {

    },
    * fetchTaskDetailNext({ payload: { taskcore, jobId } }, { put, call,select }) {
      let requestList = null;
      switch (taskcore) {
        case 'taskcore':
          requestList = taskRequest.fetchMerchantJoinTaskTemplate;
          break;
        case 'auditcore':
          requestList = taskRequest.fetchauditJobDetail;
          break;
        case 'acceptancecore':
          requestList = taskRequest.fetchcheckDetail;
          break;
      }
      if (!requestList) {return;}
      try {
        let res = yield call(requestList, { jobId });
        let editor = false, hasbtn = false;
        if (taskcore === 'auditcore') {
          if (res.job.canProcess === 1 && (res.job.processStatus === 're_do' || res.job.processStatus === 'un_do')) {
            // 做任务
            editor = true;
            hasbtn = true;
          }
          if (res.job.canAudit === 1 && res.job.auditStatus === 'un_audit') {
            // 审核
            editor = false;
            hasbtn = true;
          }
          if (res.job.canAudit === 1 && !res.job.auditStatus) {
            editor = false;
            hasbtn = false;
          }
        }
        let { job = {}} = res || {};
        if (taskcore === 'taskcore' && (job.processStatus === 'un_do' || job.processStatus == 're_do')) {
          editor = true;
          hasbtn = true;
        }
        if (taskcore === 'acceptancecore' && job.checkStatus === 'un_check') {
          hasbtn = true;
        }

        if (res && res.histories) {
          (res.histories || []).forEach(item=> {
            item.log = taskServices.filterLog(item);
            item.name = taskServices.filterNameByStatus(item);
          });
        }
        yield put({
          type: 'save',
          payload: {
            taskDetailNext: {
              hasbtn, editor, data: res,
            },
          },
        });
      } catch (error) {
        console.log(error);
      }
    },
  },
};
