package com.xkshop.view_manager;

import androidx.fragment.app.Fragment;
import android.view.LayoutInflater;

import com.alibaba.android.arouter.launcher.ARouter;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.xkshop.MainApplication;
import com.xkshop.R;

import java.util.Map;

import javax.annotation.Nullable;

import cn.scshuimukeji.im.core.application.ROUTER;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/1/18 13:59
 * Desc:
 */
public class MerchantFriendScreenManager extends SimpleViewManager<CusLinearLayout> {

    public static final String REACT_CLASS = "MerchantFriendFrameLayout";

    public static final int COMMAND_CREATE = 1001;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected CusLinearLayout createViewInstance(ThemedReactContext reactContext) {
        CusLinearLayout root = (CusLinearLayout) LayoutInflater.from(reactContext)
                .inflate(R.layout.friend_circle_layout, null);
        return root;
//        return new MerchantFriendFrameLayout(reactContext);
    }

    @Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
        return MapBuilder.of(
                "create", COMMAND_CREATE
        );
    }

    @Override
    public void receiveCommand(CusLinearLayout root, int commandId, @Nullable ReadableArray args) {
        switch (commandId) {
            case COMMAND_CREATE:
                createFragment();
                break;
        }
    }

    private void createFragment() {
        Fragment friendFragment = (Fragment) ARouter.getInstance().build(ROUTER.IM_MERCHANT_HOME).navigation();

        MainApplication.getInstance()
                .getFragmentActivity()
                .getSupportFragmentManager()
                .beginTransaction()
                .add(R.id.container_view, friendFragment)
                .commit();
    }
}
