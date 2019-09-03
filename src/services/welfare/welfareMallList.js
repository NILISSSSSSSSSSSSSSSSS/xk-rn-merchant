// 处理列表加载更多和刷新
/**
 *
 * @param {*Object} params // 参数
 * @param {*Object} respone // 接口返回数据
 * @param {*Arrary} prevData // 已经获取的数据
 */
export function handleListLoadMore(params, respone, prevData) {
  let _data;
  if (params.page === 1) {
    _data = respone ? respone.data : [];
  } else {
    _data = respone ? [...prevData.data, ...respone.data] : prevData.data;
  }
  const _total = params.page === 1
    ? (respone)
      ? respone.total
      : 0
    : prevData.total;
  const hasMore = respone ? _total !== _data.length : false;
  return {
    data: _data,
    params: {
      page: params.page,
      limit: params.limit,
      refreshing: false,
      hasMore,
      total: _total,
    },
  };
}
/**
 * 获取夺奖派对数据
 * @param {Object} params 请求参数
 * @param {Number} nowStatusIndex 当前分类索引
 * @param {Object} respone 服务器响应数据
 * @param {Objecg} prevData 已经获取的数据 用作loadMore累加
 */
export function handleStatusListLoadMore(params, nowStatusIndex, respone, prevData) {
  const _prevCategoryData = prevData[nowStatusIndex] ? prevData[nowStatusIndex] : [];
  let _data;
  if (params.page === 1) {
    _data = respone ? respone.data : [];
  } else {
    _data = respone ? [..._prevCategoryData.data, ...respone.data] : _prevCategoryData.data;
  }
  const _total = params.page === 1
    ? (respone)
      ? respone.total
      : 0
    : prevData.total;
  const hasMore = respone ? _total !== _data.length : false;
  prevData[nowStatusIndex] = {
    data: _data,
    params: {
      page: params.page,
      limit: params.limit,
      refreshing: false,
      hasMore,
      total: _total,
    },
  };
  return prevData;
}
