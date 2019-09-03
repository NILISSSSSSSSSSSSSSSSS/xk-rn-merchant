package com.xkshop.im;

import android.content.Intent;
import android.graphics.Color;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Toast;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.xkshop.R;

import cn.scshuimukeji.comm.ui.title.MultipleTitleBar;
import cn.scshuimukeji.im.BaseActivity;
import cn.scshuimukeji.im.core.application.ROUTER;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/1/26 22:11
 * Desc:   商联消息原生页面
 */
@Route(path = "/merchant/friend")
public class FriendActivity extends BaseActivity implements View.OnClickListener {

    @Override
    protected void loadData() {
        Fragment fragment = (Fragment) ARouter.getInstance().build(ROUTER.IM_MERCHANT_HOME).navigation();
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.add(R.id.frame_layout, fragment).commit();
    }

    @Override
    protected int getLayoutId() {
        return R.layout.activity_friend;
    }

    @Override
    protected void initTitleBar(MultipleTitleBar multipleTitleBar) {
        setTitleBarVisibility(false);
    }

    @Override
    protected void initView() {
        setStatusColor(Color.TRANSPARENT, true, false);
        findViewById(R.id.home_tv).setOnClickListener(this);
        findViewById(R.id.shop_tv).setOnClickListener(this);
        findViewById(R.id.service_tv).setOnClickListener(this);
        findViewById(R.id.me_tv).setOnClickListener(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    public void onClick(View v) {
        int param = 0;
        switch (v.getId()) {
            case R.id.home_tv:
            default:
                param = 0;
                break;
            case R.id.shop_tv:
                param = 1;
                break;
            case R.id.service_tv:
                param = 2;
                break;
            case R.id.me_tv:
                param = 4;
                break;
        }
//        XKMerchantEventEmitter.sendJumpRNEvent(MainApplication.getInstance().getReactApplicationContext(), param);
        finish();
    }

    /**
     * 双击返回桌面
     */
    private long backTime = 0;

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if ((System.currentTimeMillis() - backTime > 2000)) {
                Toast.makeText(this, "再按一次退出应用", Toast.LENGTH_SHORT).show();
                backTime = System.currentTimeMillis();
            } else {
                Intent intent = new Intent(Intent.ACTION_MAIN);
                intent.addCategory(Intent.CATEGORY_HOME);
                startActivity(intent);
            }
            return true;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(0, R.anim.fade_out);
    }
}
