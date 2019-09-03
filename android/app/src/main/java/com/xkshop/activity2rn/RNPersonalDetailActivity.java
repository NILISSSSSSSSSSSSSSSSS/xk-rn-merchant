package com.xkshop.activity2rn;

import android.app.Activity;
import android.os.Bundle;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.facebook.react.ReactActivity;
import com.facebook.react.ReactActivityDelegate;

import javax.annotation.Nullable;

import cn.scshuimukeji.comm.util.StatusUtil;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019-05-15 14:09
 * Desc:   RN个人详情页面
 */
@Route(path = "/react/personalDetail")
public class RNPersonalDetailActivity extends ReactActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        StatusUtil.setSystemStatus(this, false, true);
    }

    @Nullable
    @Override
    protected String getMainComponentName() {
        return "Profile";
    }

    /**
     * 在delegate代理执行onCreate方法之前，获取activity中的由上个页面传入的参数
     */
    public class PersonalDetailActivityDelegate extends ReactActivityDelegate {
        private Bundle mInitialProps = null;
        private Activity activity;

        public PersonalDetailActivityDelegate(Activity activity, @Nullable String mainComponentName) {
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
        return new RNPersonalDetailActivity.PersonalDetailActivityDelegate(this, getMainComponentName());
    }
}
