package com.xkshop;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.xkshop.view_manager.MerchantCusServiceScreenManager;
import com.xkshop.view_manager.MerchantFriendScreenManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class XKMerchantPackage implements ReactPackage {

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();

        modules.add(new XKMerchantModule(reactContext));

        return modules;
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.asList(new MerchantFriendScreenManager(),
                new MerchantCusServiceScreenManager());
    }
}
