
// 将服务器数据和本地合并
export function filterCategoryLists({ data, coustomCategoryList = [] }) {
    if (coustomCategoryList.length === 0) {
        return data;
    }
    for (let i = 0; i < data.length; i++) {
        // pre_selected 默认null，用户已选择true，用户删除false
        data[i].pre_selected = null;
        for (let j = 0; j < coustomCategoryList.length; j++) {
            if (data[i].code == coustomCategoryList[j].code) {
                data[i].pre_selected = coustomCategoryList[j].pre_selected;
            }
        }
    }
    // 用户删除的排在最后
    let data_sys = [];
    let data_pre = [];
    let data_other = [];
    let data_other2 = [];
    for (let i = 0; i < coustomCategoryList.length; i++) {
        if (coustomCategoryList[i].moveEnable === 0) {
            data_sys.push(data[i]);
        } else {
            if (coustomCategoryList[i].pre_selected) {
                data_pre.push(coustomCategoryList[i]);
            } else if (coustomCategoryList[i].pre_selected == false) {
                data_other2.push(coustomCategoryList[i]);
            } else {
                data_other.push(coustomCategoryList[i]);
            }
        }
    }
    data = [...data_sys, ...data_pre, ...data_other, ...data_other2];
    return data
}

export function initCategoryTitleStatus({ data }) {
    let _data = [];
    for (let i = 0; i < data.length; i++) {
        // status  active 激活，del 删除
        if (data[i].status == "active") {
            _data.push(data[i]);
        }
    }
    return _data
}

export function initSelectedStatus(data = [], selectIndex = 0) {
    let _modalCategoryLists = data;
    _modalCategoryLists.map((item, index) => {
        if (index === selectIndex) { item.selected_status = true; } else { item.selected_status = false }
    })
    return _modalCategoryLists
}

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
    let _total = params.page === 1
        ? (respone)
            ? respone.total
            : 0
        : prevData.total;
    let hasMore = respone ? _total !== _data.length : false;
    return {
        data: _data,
        params: {
            page: params.page,
            limit: params.limit,
            refreshing: false,
            hasMore,
            total: _total,
        }
    }
}
/**
 * 处理分类商品列表数据
//  * @param {*Object} paylItem 请求参数，修改数据
//  * @param {*Arrary} paylData 已获取购物车列表数据
//  * @param {*Arrary} prevData 已获取购物车列表数据
 */
// 修改购物车
export function handleListToItem(paylItem, paylData, prevData) {
    if (paylItem) {
        return prevData.map(preItem => { preItem.id === paylItem.id ? preItem = paylItem : {} })
    }
    return paylData
}
/**
 * 处理分类商品列表数据
 * @param {Object} params 请求参数
 * @param {Number} nowCategoryIndex 当前分类索引
 * @param {Object} respone 服务器响应数据
 * @param {Objecg} prevData 已经获取的数据 用作loadMore累加
 */
export function handleCategotyListLoadMore(params, nowCategoryIndex, respone, prevData) {
    let _prevCategoryData = prevData[nowCategoryIndex] ? prevData[nowCategoryIndex] : [];
    let _data;
    if (params.page === 1) {
        _data = respone ? respone.data : [];
    } else {
        _data = respone ? [..._prevCategoryData.data, ...respone.data] : _prevCategoryData.data;
    }
    let _total = params.page === 1
        ? (respone)
            ? respone.total
            : 0
        : prevData.total;
    let hasMore = respone ? _total !== _data.length : false;
    prevData[nowCategoryIndex] = {
        data: _data,
        params: {
            page: params.page,
            limit: params.limit,
            refreshing: false,
            hasMore,
            total: _total,
        }
    }
    return prevData
}

/**
 * 处理分类商品列表数据
 * @param {*Arrary} paramsData 请求参数,移除的数据
 * @param {*Arrary} prevData 获取的购物车数据，Array
 */
export function handldleFilterMove(prevData, paramsData) {
    let newData = prevData.filter(_ => !paramsData.includes(_));
    if (newData.length === 0) {
        return []
    }
    return newData;
}
