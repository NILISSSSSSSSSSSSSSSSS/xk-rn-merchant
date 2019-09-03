# 代码规范

## 1. 书写便于维护的代码

#### 1.1. 常量或者枚举类型

**1.1.1. 全局常量命名**

    const NODE_DEV = "development" 单词之间大写，中间用下划线

**1.1.2. 文件中常量**

    const TabsList = [
        { key: "001", value: "首页"},
        { key: "002", value: "店铺"},
        { key: "003", value: "我的"},
    ]

注：文件中，尽量使用常量替换一些数值的表示的类型。

#### 1.2. 函数命名规范

**1.2.1. 函数命名开头表示类型或者动作**

    renderItem // 渲染函数
    onPress // 按钮执行事件(props传递)
    handlePress // 页面上点击事件处理函数
    fetchMessageList // 获取数据

#### 1.3. 组件命名(RN中主要是ref命名)

    ```jsx
    <ActionSheet ref={dom=> this.asXXX = dom }> // 首字母
    <Button ref={dom=> this.btnXXX = dom }> // 约定熟成
    <TextInput ref={dom=> this.textXXXX = dom }> // 取组件名称第一部分
    ```

#### 1.4. 常用函数封装

**1.4.1. 金额展示**

```js
{
    changeY2F(price), // 分转元
    changeF2Y(price), // 元转分
}
```
#### 1.5. 常用组件封装

**1.5.1. Button 按钮**
Button ToggleButton IconButton
**1.5.2. List 列表**
List ListItem Splitter 
**1.5.3. FixedFooter 底部按钮**
FixedFooter FixedSpacer FixedTips
**1.5.4 Form 表单组件**
TextInputView Switch 


#### 1.6 逻辑判断

1. if嵌套语句复杂

    ```js
    // 连续if嵌套
    if(condition1) {
        if(condition2) {
            if(condition3) {
                dosth;
            }
        }
    }

    // 修改为
    if(condition1 && condition2 && condition3) { 
        dosth; 
    }

    // 如果条件语句太长的，修改为
    const condition  = condition1 && condition2 && condition3;
    if(condition) { 
        dosth; 
    }
    ```

    ```js
    // 连续if嵌套,且需要做事情的
    if(condition1) {
        dosth1;
        if(condition2) {
            dosth2;
            if(condition3) {
                dosth3;
            }
        }
    }

    // 修改为
    if(!condition1) return;
    dosth1;
    if(!condition2) return;
    dosth2;
    if(!condition3) return;
    dosth3;
    ```

2. 相同字段的if判断

    ```js
    // 对多个字符串判断的if语句
    const condition = "somestring"

    if(condition === "somestring1") {
        dosth1;
    }

    if(condition === "somestring2") {
        dosth2;
    }

    // 修改为(新增枚举类型，对变量switch判断)
    const sstrEnum = {
        "somestring": "somestring",
        "somestring1":  "somestring1",
        "somestring2": "somestring2",
    }
    const condition = "somestring"
    switch(condition) {
        case sstrEnum.somestring1: dosth1; break;
        case sstrEnum.somestring2: dosth2; break;
        default: break;
    }
    ```

## 2. dva中常用功能封装

#### 2.1. 列表数据（分页功能）

注：目前需要统一写法
```js
{
    pagination: {
        hasMore: false, // 是否有更多数据
        isFirstLoad: false, // 是否第一次访问
        loading: true, // 是否正在请求数据
        refreshing: true, // 是否正在刷新数据 page等于1的时候触发
        page: 1, // 页数
        limit: 10, // 每页限制数据
        total: 0, // 列表数据总数
    },
    list: []
}
```

#### 2.2. 导航行为

注：目前已经统一调用 `models/system.js` 下的若干导航方法

#### 2.3. 页面上connect规范写法

```js
// 页面上需要什么参数，就获取什么参数，避免多个页面持续刷新带来页面卡顿问题
connect(state=> {
    list: state.shop.shopList.list || [],
    pagination: state.shop.shopList.pagination || {}
}, {
    fetchList: (shopId, page = 1, limit = 10)=> ({ type: "shop/getList", payload: { shopId, page, limit }})
})(PageScreens)
```

#### 2.4. 异常处理

**2.4.1. effects 需要手动书写try catch 捕获异常**
```js
{
    effects: {
        *fetchList({ payload: params }, { put, call ,select }) {
            try{
                // xxx
            } catch(error) {
                Toast.show("获取列表失败")
            }
        }
    }
}
```
