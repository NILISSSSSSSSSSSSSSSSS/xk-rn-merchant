package com.xkshop.promise;

import com.facebook.react.bridge.Promise;

/**
 * @Project XKGC
 * @Describe
 * @Author 鲍立志
 * @Date 2019/1/7
 * @Time 11:38
 */
public class BackPressedPromise {

    private static volatile BackPressedPromise mInstance;
    private Promise promise;

    private BackPressedPromise() {
    }

    public static BackPressedPromise getInstance() {
        if (mInstance == null) {
            synchronized (BackPressedPromise.class) {
                if (mInstance == null) {
                    mInstance = new BackPressedPromise();
                }
            }
        }
        return mInstance;
    }

    public void initPromise(Promise promise) {
        this.promise = promise;
    }

    public void resolve(Object value) {
        if (this.promise == null) return;
        this.promise.resolve(value);
        this.promise = null;
    }
}
