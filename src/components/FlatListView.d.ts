import React, { PureComponent, ReactElement , ReactText } from 'react'
import { ViewStyle } from 'react-native'
import { ListEmptyComType } from './ListEmptyCom';

type FlatListViewType = "default" | ListEmptyComType

interface FlatListViewProps {
    /** 要显示的列表数据 */
    data: object[],
    renderItem: ({ item: object, index: number }) => ReactElement | ReactText,
    /** 加载第一页数据 */
    refreshData: Function,
    /** 加载更多数据 */
    loadMoreData: Function,
    limit: number,
    store: {
        /** 是否正在刷新第一页数据 */
        refreshing: boolean,
        /** 是否还有更多的数据 */
        hasMore: boolean,
    },
    /** 是否需要刷新组件 */
    refreshControl?: boolean,
    /** 列数，默认为1 */
    numColumns?: number,
    flatRef?: Function, 
    ListEmptyComponent?: ReactElement | ReactText,
    ListHeaderComponent?: ReactElement | ReactText,
    ListFooterComponent?: ReactElement | ReactText,
    ItemSeparatorComponent?: ReactElement | ReactText,
    onScroll?: Function,
    contentContainerStyle?: ViewStyle,
    type?: FlatListViewType,
    openWaterFall?: false,
}

export default class FlatListView extends PureComponent<FlatListViewProps> {}