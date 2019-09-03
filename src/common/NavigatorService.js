// copy from https://github.com/react-community/react-navigation/issues/1439
// https://reactnavigation.org/docs/en/navigating-without-navigation-prop.html

import { StackActions, NavigationActions } from 'react-navigation';
let _container;

function setContainer(container) {
    _container = container;
}

function reset(routeName, params) {
    _container.dispatch(
        StackActions.reset({
            index: 0,
            actions: [
                NavigationActions.navigate({
                    type: 'Navigation/NAVIGATE',
                    routeName,
                    params,
                }),
            ],
        }),
    );
}

function resetTab(routeName, params) {
    _container.dispatch(
        StackActions.reset({
            index: 0,
            actions: [
                NavigationActions.navigate({
                    routeName: "Index",
                    params: {},
                    action: NavigationActions.navigate({ routeName:routeName, params  }),
                }),
            ]
        })
    )
}

function navigate(routeName, params) {
    _container.dispatch(
        NavigationActions.navigate({
            type: 'Navigation/NAVIGATE',
            routeName,
            params,
        }),
    );
}
/**
 * 回退到指定堆栈路由
 * @param {string} routeName 路由名称
 * @param {boolean} immediate 是否立即回退
 */
function popToRouteName(routeName, immediate = true) {
    let routes = _container.state.routes;
    let curIndex = _container.state.index;
    let popIndex = routes.findIndex(route=> route.routeName === routeName);
    if(popIndex!==-1) {
        let num = curIndex - popIndex;
        _container.dispatch(
            StackActions.pop({
                n: num,
                immediate
            })
        )
        return routes.find(route=> route.routeName === routeName);
    }
    return null;
}
/**
 * 查找指定路由
 * @param {string} routeName 路由名称
 */
function findRouteByRouteName(routeName) {
    let routes = _container.state.routes;
    let popIndex = routes.findIndex(route=> route.routeName === routeName);
    if(popIndex!==-1) {
        return routes.find(route=> route.routeName === routeName);
    }
    return null;
}

function navigateDeep(actions) {
    _container.dispatch(
        actions.reduceRight(
            (prevAction, action) =>
                NavigationActions.navigate({
                    type: 'Navigation/NAVIGATE',
                    routeName: action.routeName,
                    params: action.params,
                    action: prevAction,
                }),
            undefined,
        ),
    );
}

function getState() {
    if (!_container || !_container.state) {
        return null
    }
    return _container.state
}

function getCurrentRoute() {
    if (!_container || !_container.state) {
        return null;
    }

    return _container.state.routes[_container.state.index] || null;
}

export default {
    setContainer,
    navigateDeep,
    popToRouteName,
    navigate,
    reset,
    getCurrentRoute,
    getState,
    resetTab,
    findRouteByRouteName,
};
