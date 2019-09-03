package com.xkshop.promise;

import com.facebook.react.bridge.Promise;
import com.xkshop.share.ShareBean;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/3/14 14:32
 * Desc:
 */
public class SharePromise {
    private static volatile SharePromise mInstance;
    private Promise promise;
    private ShareBean shareBean;

    private SharePromise() {
    }

    public static SharePromise getInstance() {
        if (mInstance == null) {
            synchronized (SharePromise.class) {
                if (mInstance == null) {
                    mInstance = new SharePromise();
                }
            }
        }
        return mInstance;
    }

    public void initPromise(Promise promise, ShareBean shareBean) {
        this.promise = promise;
        this.shareBean = shareBean;
    }

    public ShareBean getShareBean() {
        return shareBean;
    }

    public void resolve(Object value) {
        if (this.promise == null) return;
        this.promise.resolve(value);
        this.promise = null;
    }

    public void reject(String code, String message) {
        if (this.promise == null) return;
        this.promise.reject(code, message);
        this.promise = null;
    }
}
