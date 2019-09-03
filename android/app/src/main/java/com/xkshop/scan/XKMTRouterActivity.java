package com.xkshop.scan;

import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.View;

import com.alibaba.android.arouter.launcher.ARouter;

import cn.scshuimukeji.comm.RouterActivity;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/4/4 14:33
 * Desc:
 */
public class XKMTRouterActivity extends RouterActivity {
    @Override
    public int onViewLayout() {
        return 0;
    }

    @Override
    public void onViewCreate(View view) {
        Uri uri = getIntent().getData();
        ARouter.getInstance().build(uri).navigation();
        finish();
    }

    @Override
    public void onViewFirstStart() {

    }

    @Override
    public void onViewStart() {

    }

    @Override
    public void onStateSave(Bundle state) {

    }

    @Override
    public void onStateResume(@Nullable Bundle state) {

    }
}
