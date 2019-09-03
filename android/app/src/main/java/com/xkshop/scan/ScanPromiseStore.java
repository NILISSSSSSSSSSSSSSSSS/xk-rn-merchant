package com.xkshop.scan;

import com.facebook.react.bridge.Promise;

/**
 * @Describe
 * @Author 鲍立志
 * @Date 2018/9/28

 */
public class ScanPromiseStore {
    private static volatile ScanPromiseStore mInstance;
    public Promise scanPromise;

    private ScanPromiseStore() {}

    public static ScanPromiseStore getInstance() {
        if (mInstance == null) {
            synchronized (ScanPromiseStore.class) {
                if (mInstance == null) {
                    mInstance = new ScanPromiseStore();
                }
            }
        }
        return mInstance;
    }
}
