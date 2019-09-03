package com.xkshop.promise;

import com.facebook.react.bridge.Promise;

/**
 * @Project XKGC
 * @Describe
 * @Author 鲍立志
 * @Date 2019/1/23
 * @Time 19:40
 */
public class ContactPromise {

    private static volatile ContactPromise mInstance;
    private Promise promise;

    private ContactPromise() {
    }

    public static ContactPromise getInstance() {
        if (mInstance == null) {
            synchronized (ContactPromise.class) {
                if (mInstance == null) {
                    mInstance = new ContactPromise();
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
