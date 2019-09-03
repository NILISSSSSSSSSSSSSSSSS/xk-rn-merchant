package com.xkshop.view_manager;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/1/25 23:54
 * Desc:
 */
public class FriendScreenManager extends ViewGroupManager<FriendScreenFrameLayout> {
    @Override
    public String getName() {
        return "MerchantFriendFrameLayout";
    }

    @Override
    protected FriendScreenFrameLayout createViewInstance(ThemedReactContext reactContext) {
        return new FriendScreenFrameLayout(reactContext);
    }
}
