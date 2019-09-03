package com.xkshop.im;

import android.content.Intent;

import com.alibaba.android.arouter.launcher.ARouter;
import com.netease.nimlib.sdk.msg.model.IMMessage;
import com.xkshop.SplashActivity;

import java.util.ArrayList;

import cn.scshuimukeji.database.XKDBClient;
import cn.scshuimukeji.database.table.annotations.DefValue;
import cn.scshuimukeji.database.table.im.IMSessionInfo;
import cn.scshuimukeji.database.table.im.IMUserInfo;
import cn.scshuimukeji.im.notification.NotificationActivity;
import io.reactivex.SingleObserver;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

/**
 * 通知 Activity.
 * 【注意】
 * ① 主题要设置成透明的？
 * ② 启动模式 android:launchMode="singleTask" ？
 * <p>
 * Created by 向小勇 at 2019/02/15 0015
 */
public class IMNotificationActivity extends NotificationActivity implements SingleObserver<IMUserInfo> {
    // 标识应用是否是从LAUNCH页面启动，点击消息推送
    public static boolean isLaunchStart = false;
    private Disposable disposable;
    private IMSessionInfo imSessionInfo;
    private ArrayList<IMMessage> messages;

    public static final String FLAG_MESSAGE_HOME = "messageHome";
    public static final String FLAG_PLATFORM_SERVICE = "platformService";
    public static final String FLAG_SHOP_SERVICE = "shopService";
    public static final String FLAG_OFFICIAL_GROUP = "officialGroup";

    /**
     * 点击通知栏，点击三方push来的消息时，参数都会为null
     * 调用在主线程,应该在此方法中判断用户是否登录,应用是否已经启动(从初始页面进入？防止某些初始化页面做的事情没有做),以及通过参数判断跳往的界面
     *
     * @param imSessionInfo 会话信息【注意】:有可能为空，默认为空跳消息主页
     * @param messages      消息列表【注意】:有可能为空，默认为空跳消息主页
     * @return 无作用暂留，返回true。 false留作它用
     */
    @Override
    public boolean onNotifyClick(IMSessionInfo imSessionInfo, ArrayList<IMMessage> messages) {
        // 判断是否已经登录
        this.imSessionInfo = imSessionInfo;
        this.messages = messages;
        XKDBClient.getInstance().opened().userInfoDao().queryCurrentUserInfoS()
                .subscribeOn(Schedulers.io())
                .subscribeOn(AndroidSchedulers.mainThread())
                .subscribe(this);
        return true;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (disposable != null && !disposable.isDisposed()) {
            disposable.dispose();
        }
        disposable = null;
    }

    /**
     * 启动页
     */
    private void startToLaunch() {
        startActivity(new Intent(this, SplashActivity.class));
        finish();
    }

    /**
     * 主页
     *
     * @param flag 1消息主页，2平台客服聊天界面，3店铺客服主页，4联盟商群主页
     */
    private void startToMain(String flag) {
        ARouter.getInstance().build("/react/home")
                .withString("messageJumpFlag", flag)
                .navigation();
        finish();
    }

    /**
     * 订阅
     */
    @Override
    public void onSubscribe(Disposable d) {
        disposable = d;
    }

    /**
     * 查询成功
     *
     * @param imUserInfo the item emitted by the Single
     */
    @Override
    public void onSuccess(IMUserInfo imUserInfo) {
        // 已登录
        if (imSessionInfo == null) {
            // 跳转到消息主页
            startToMain(FLAG_MESSAGE_HOME);
        } else {
            switch (imSessionInfo.subType) {
                // 单聊 - 临时会话
                case DefValue.SESSION_SUB_TYPE_P2P_TEMPORARY:
                    // 单聊 - 可友会话
                case DefValue.SESSION_SUB_TYPE_P2P_FRIEND:
                    // 单聊 - 密友会话
                case DefValue.SESSION_SUB_TYPE_P2P_SECRET:
                    // 群聊 - 普通会话
                case DefValue.SESSION_SUB_TYPE_TEAM_NORMAL:
                    // 群聊 - 粉丝群会话
                case DefValue.SESSION_SUB_TYPE_TEAM_FANS:
                    // 系统消息 - 普通消息
                case DefValue.SESSION_SUB_TYPE_SYSTEM_NORMAL:
                    // 聊天室 - 普通聊天室
                case DefValue.SESSION_SUB_TYPE_CHAT_ROOM_NORMAL:
                    // 聊天室 - 直播聊天室
                case DefValue.SESSION_SUB_TYPE_CHAT_ROOM_LIVE:
                default:
                    startToMain(FLAG_MESSAGE_HOME);
                    break;

                // 群聊 - 联盟商 - 平台客服会话
                case DefValue.SESSION_SUB_TYPE_TEAM_CUSTOMER:
                    startToMain(FLAG_PLATFORM_SERVICE);
                    break;

                // 群聊 - 客服 - 店铺客服会话
                case DefValue.SESSION_SUB_TYPE_TEAM_SHOP_CUSTOMER:
                    startToMain(FLAG_SHOP_SERVICE);
                    break;

                // 群聊 - 联盟商 - 个人群会话
                case DefValue.SESSION_SUB_TYPE_TEAM_PERSONAL:
                    // 群聊 - 联盟商 - 直播群会话
                case DefValue.SESSION_SUB_TYPE_TEAM_LIVE:
                    // 群聊 - 联盟商 - 家族长群会话
                case DefValue.SESSION_SUB_TYPE_TEAM_FAMILY:
                    // 群聊 - 联盟商 - 商户群会话
                case DefValue.SESSION_SUB_TYPE_TEAM_MERCHANT:
                    // 群聊 - 联盟商 - 合伙人群会话
                case DefValue.SESSION_SUB_TYPE_TEAM_PARTNER:
                    startToMain(FLAG_OFFICIAL_GROUP);
                    break;
            }
        }
    }

    /**
     * 查询失败
     *
     * @param e the exception encountered by the Single
     */
    @Override
    public void onError(Throwable e) {
        // 未登录
        // 直接启动页走一波
        startToLaunch();
    }
}
