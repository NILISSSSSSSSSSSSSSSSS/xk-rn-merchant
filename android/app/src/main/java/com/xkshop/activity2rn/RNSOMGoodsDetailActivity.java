package com.xkshop.activity2rn;

import android.app.Activity;
import android.os.Bundle;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.facebook.react.ReactActivity;
import com.facebook.react.ReactActivityDelegate;

import javax.annotation.Nullable;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/3/20 16:01
 * Desc:   原生页面内嵌套RN商品详情页面
 */

@Route(path = "/react/somGoodsDetail")
public class RNSOMGoodsDetailActivity extends ReactActivity {

    @Nullable
    @Override
    protected String getMainComponentName() {
        return "SOMGoodsDetail";
    }

    /**
     * 在delegate代理执行onCreate方法之前，获取activity中的由上个页面传入的参数
     */
    public class SOMGoodsActivityDelegate extends ReactActivityDelegate {
        private Bundle mInitialProps = null;
        private Activity activity;

        public SOMGoodsActivityDelegate(Activity activity, @Nullable String mainComponentName) {
            super(activity, mainComponentName);
            this.activity = activity;
        }

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            Bundle bundle = activity.getIntent().getExtras();
            if (bundle != null) {
                mInitialProps = bundle;
            }
            super.onCreate(savedInstanceState);
        }

        @Nullable
        @Override
        protected Bundle getLaunchOptions() {
            return mInitialProps;
        }
    }

    /**
     * 向RN中传递参数
     */
    @Override
    protected ReactActivityDelegate createReactActivityDelegate() {
        return new SOMGoodsActivityDelegate(this, getMainComponentName());
    }
}
