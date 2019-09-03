package com.xkshop;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.xkshop.redpoint.RedPointManager;

import cn.scshuimukeji.comm.util.LoggerUtil;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/3/12 10:54
 * Desc:   原生向RN页面发送数据
 */
public class XKMerchantEventEmitter {

    /**
     * 跳转到RN页面 好友页面
     *
     * @param param RN页面标记
     *              1001 我的二维码页面
     */
    public static void sendJumpRNFriendEvent(ReactContext reactContext, String param) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("jumpRNPage", param);
    }

    /**
     * 跳转到商品详情
     *
     * @param goodsId 商品ID
     */
    public static void jumpGoodsDetailEvent(ReactContext reactContext, String goodsId) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("goodsDetail", goodsId);
    }

    /**
     * 跳转到福利详情
     *
     * @param goodsId    商品ID
     * @param goodsName  商品name
     * @param sequenceId 福利 期ID
     */
    public static void jumpWelfareDetailEvent(ReactContext reactContext, String goodsId, String goodsName, String sequenceId) {
        WritableMap map = Arguments.createMap();
        map.putString("goodsId", goodsId);
        map.putString("goodsName", goodsName);
        map.putString("sequenceId", sequenceId);
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("welfareDetail", map);
    }

    /**
     * 发送下载进度至RN
     */
    public static void sendProgressRNEvent(ReactContext reactContext, String eventName, int param) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("downloadProgress", param);
    }

    /**
     * 发送登录token失效给RN
     */
    public static void sendLoginTokenFail(ReactContext reactContext, String code, String message) {
        WritableMap map = Arguments.createMap();
        map.putString("code", code);
        map.putString("message", message);
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
            .emit("loginTokenFail", map);
    }

    /**
     * 通知RN消息状态发生改变.
     */
    public static void friendRedPointStatusChange(ReactContext reactContext, boolean messageChanaged) {
//        LoggerUtil.warning("XKMerchantEventEmitter-Logger", "main:" + RedPointManager.getInstance().isHasMainMsg() +
//            ", xk:" + RedPointManager.getInstance().isHasXKMsg() +
//            ", shop:" + RedPointManager.getInstance().isHasShopMsg() +
//            ", union:" + RedPointManager.getInstance().isHasUnionMsg());

        if (reactContext != null && reactContext.hasActiveCatalystInstance() && RedPointManager.getInstance().shouldEmitEvent()) {
            LoggerUtil.warning("XKMerchantEventEmitter-Logger", "friendRedPointStatusChange");

            WritableMap map = Arguments.createMap();
            map.putString("status", "1");
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("friendRedPointStatusChange", map);
            RedPointManager.getInstance().setLastMsgStatus();
        }
    }

    /**
     * 发送系统消息给RN
     *
     * @param reactContext
     * @param sysMsg       系统消息json
     */
    public static void sendSystemMessageToRN(ReactContext reactContext, String sysMsg) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
            .emit("systemMessage", sysMsg);
    }
}
