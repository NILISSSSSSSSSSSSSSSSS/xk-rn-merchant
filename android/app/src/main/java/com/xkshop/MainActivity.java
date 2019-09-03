package com.xkshop;


import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;

import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.ViewModelProviders;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.facebook.react.ReactActivity;
import com.tencent.connect.common.Constants;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;
import com.umeng.analytics.MobclickAgent;
import com.xkshop.im.IMNotificationActivity;
import com.xkshop.redpoint.RedPointManager;
import com.xkshop.redpoint.RedPointVM;
import com.xkshop.view_manager.MerchantCusServiceScreenManager;

import org.devio.rn.splashscreen.SplashScreen;

import cn.jpush.android.api.JPushInterface;
import cn.scshuimukeji.comm.rx.RxBus;
import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.database.table.annotations.DefValue;
import cn.scshuimukeji.database.table.im.IMSessionInfo;
import cn.scshuimukeji.flow.FlowUtil;
import cn.scshuimukeji.im.core.application.ROUTER;
import cn.scshuimukeji.im.customer_service.ServiceChatManager;

@Route(path = "/react/home")
public class MainActivity extends ReactActivity {

    @Autowired(name = "messageJumpFlag")
    public String messageJumpFlag;

    private RedPointVM redPointVM;

    @Override
    protected void onPause() {
        super.onPause();
        JPushInterface.onPause(this);
        MobclickAgent.onPause(this);

        LoggerUtil.warning("MainActivity-Logger", "onPause");
    }

    @Override
    protected void onResume() {
        super.onResume();
        JPushInterface.onResume(this);
        MobclickAgent.onResume(this);

        LoggerUtil.warning("MainActivity-Logger", "onResume");
        //IM登录后,用户信息不为空,查询会话
        if (FlowUtil.getUser() != null && !TextUtils.isEmpty(FlowUtil.getUser().accountId)) {
            initRedDot();
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        RxBus.getIntance().unSubscribe(this);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        SplashScreen.show(this, true);
        JPushInterface.init(this);
        // startActivityForResult(new Intent(this, SplashActivity.class), 1);
        super.onCreate(savedInstanceState);

        MainApplication.getInstance().setFragmentActivity(this);

        //发送好友tab红点事件给RN
        RxBus.getIntance().subscribe(this, Integer.class, data -> {
            LoggerUtil.warning("MainActivity-Logger", "mainMsg:" + data);
            RedPointManager.getInstance().setHasMainMsg(data == View.VISIBLE);
            XKMerchantEventEmitter.friendRedPointStatusChange(MainApplication.getInstance().getReactApplicationContext(), true);
        });

        LoggerUtil.warning("MainActivity-Logger", "onCreate");

        DisplayMetrics displayMetrics = getResources().getDisplayMetrics();
        if (displayMetrics.scaledDensity != displayMetrics.density) {
            LoggerUtil.warning("MainActivity-Logger", "字体缩放比例因子被修改了");
            displayMetrics.scaledDensity = displayMetrics.density;
        }
    }

    //消息红点
    private void initRedDot() {
        redPointVM = ViewModelProviders.of(this).get(RedPointVM.class);

        // 监听店铺客服,平台客服,联盟官方群新消息
        redPointVM.getMultipleTypeSession(this, FlowUtil.getUser().accountId,
                new int[]{DefValue.SESSION_SUB_TYPE_TEAM_CUSTOMER,
                        DefValue.SESSION_SUB_TYPE_TEAM_SHOP_CUSTOMER,
                        DefValue.SESSION_SUB_TYPE_TEAM_PERSONAL,
                        DefValue.SESSION_SUB_TYPE_TEAM_LIVE,
                        DefValue.SESSION_SUB_TYPE_TEAM_FAMILY,
                        DefValue.SESSION_SUB_TYPE_TEAM_MERCHANT,
                        DefValue.SESSION_SUB_TYPE_TEAM_PARTNER})
                .observe(this, data -> {
                    if (data == null) return;
                    LoggerUtil.warning("MainActivity-Logger", "getMultipleTypeSession");
                    RedPointManager.getInstance().setHasXKMsg(false);
                    RedPointManager.getInstance().setHasShopMsg(false);
                    RedPointManager.getInstance().setHasUnionMsg(false);
                    for (IMSessionInfo info : data) {
                        if (info != null && info.unread > 0) {
                            if (info.subType == DefValue.SESSION_SUB_TYPE_TEAM_CUSTOMER) {
                                RedPointManager.getInstance().setHasXKMsg(true);
                            } else if (info.subType == DefValue.SESSION_SUB_TYPE_TEAM_SHOP_CUSTOMER) {
                                RedPointManager.getInstance().setHasShopMsg(true);
                            } else {
                                RedPointManager.getInstance().setHasUnionMsg(true);
                            }
                        }
                    }
                    XKMerchantEventEmitter.friendRedPointStatusChange(MainApplication.getInstance().getReactApplicationContext(), true);
                });
    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        ARouter.getInstance().inject(this);
        if (!TextUtils.isEmpty(messageJumpFlag)) {
            switch (messageJumpFlag) {
                case IMNotificationActivity.FLAG_MESSAGE_HOME:
                default:
                    XKMerchantEventEmitter.sendJumpRNFriendEvent(MainApplication.getInstance().getReactApplicationContext(), "FriendScreen");
                    break;
                case IMNotificationActivity.FLAG_PLATFORM_SERVICE:
                    ServiceChatManager manager = new ServiceChatManager(MainApplication.getInstance().getFragmentActivity());
                    manager.contactXKService("商联客服", MerchantCusServiceScreenManager.teamIcon);
                    break;
                case IMNotificationActivity.FLAG_SHOP_SERVICE:
                    ARouter.getInstance().build(ROUTER.IM_MERCHANT_CUSTOMER_SERVICE)
                            .withString("shopId", MainApplication.getInstance().getShopId())
                            .navigation();
                    break;
                case IMNotificationActivity.FLAG_OFFICIAL_GROUP:
                    ARouter.getInstance().build(ROUTER.IM_MERCHANT_OFFICIAL_GROUP_SESSION).navigation();
                    break;
            }
        }
        LoggerUtil.warning("MainActivity-Logger", "onNewIntent");
    }

    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "xkMerchant";
    }

    @Override
    public Lifecycle getLifecycle() {
        return super.getLifecycle();
    }

    public static IUiListener qqShareListener = new IUiListener() {
        @Override
        public void onComplete(Object response) {
            //分享成功

        }

        @Override
        public void onError(UiError uiError) {
            //分享失败

        }

        @Override
        public void onCancel() {
            //分享取消

        }
    };


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Tencent.onActivityResultData(requestCode, resultCode, data, qqShareListener);
        if (requestCode == Constants.REQUEST_API) {
            if (resultCode == Constants.REQUEST_QQ_SHARE || resultCode == Constants.REQUEST_QZONE_SHARE || resultCode == Constants.REQUEST_OLD_SHARE) {
                Tencent.handleResultData(data, qqShareListener);
                return;
            }
        } else if (requestCode == Constants.REQUEST_QQ_SHARE) {
            return;
        }
    }
}
