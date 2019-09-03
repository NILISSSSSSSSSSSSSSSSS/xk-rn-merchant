package com.xkshop.util;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.widget.Toast;

import cn.scshuimukeji.comm.CommApplication;
import cn.scshuimukeji.comm.errors.BusinessException;
import cn.scshuimukeji.comm.util.L;
import cn.scshuimukeji.flow.Response;
import cn.scshuimukeji.im.core.widget.dialog.CustomProgressDialogManager;
import io.reactivex.observers.DisposableObserver;

/**
 * @author FanCoder.LCY
 * @date 2018/9/12 11:46
 * @email 15708478830@163.com
 * @desc 观察者抽象基类
 **/
public abstract class XKSLObserver<T> extends DisposableObserver<T> {
    public XKSLObserver() {
    }

    @Override
    protected void onStart() {
        super.onStart();
        L.i("onStart");

        if (!isNetworkConnected(CommApplication.getInstance())) {
            Toast.makeText(CommApplication.getInstance(), "网络不可用，请检查网络", Toast.LENGTH_SHORT).show();
            dispose();
        }
    }

    public boolean isNetworkConnected(Context context) {
        if (context != null) {
            ConnectivityManager mConnectivityManager = (ConnectivityManager) context
                .getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo mNetworkInfo = mConnectivityManager.getActiveNetworkInfo();
            if (mNetworkInfo != null) {
                return mNetworkInfo.isAvailable();
            }
        }
        return false;
    }

    @Override
    public void onNext(T t) {
        try {
            L.i("onSuccess");
            if (t instanceof Response) {
                Response response = (Response) t;
                // 判断code非200和409，则抛出业务异常，中断订阅
                if (response.code != 200 && response.code != 409) {
                    L.e(response.code + ":" + response.message);
                    onError(new BusinessException(500 == response.code ? "500" : "" + response.message));
                    return;
                }
            }
            success(t);
        } catch (Exception e) {
            L.e(e, "Exception in XKSLObserver onNext method: " + e.getMessage());
        }
    }

    @Override
    public void onError(Throwable e) {
        CustomProgressDialogManager.getInstance().dismiss();
        String message = handleObserverError(e);
        L.e(message);
        try {
            error(message);
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }

    @Override
    public void onComplete() {
        L.i("onComplete");
    }


    /**
     * 数据流传递的结果
     */
    public abstract void success(T response);

    /**
     * 数据流过程中出现错误
     */
    public abstract void error(String message);

    /**
     * 统一处理错误码
     */
    private String handleObserverError(Throwable e) {
        return e.getMessage();
    }
}
