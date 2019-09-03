package com.xkshop;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.ContactsContract;
import android.provider.Settings;
import androidx.fragment.app.FragmentActivity;
import android.text.TextUtils;

import com.alibaba.android.arouter.launcher.ARouter;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.google.zxing.client.android.Intents;
import com.liulishuo.filedownloader.BaseDownloadTask;
import com.liulishuo.filedownloader.FileDownloadLargeFileListener;
import com.liulishuo.filedownloader.FileDownloader;
import com.netease.nimlib.sdk.NIMClient;
import com.netease.nimlib.sdk.SDKOptions;
import com.netease.nimlib.sdk.StatusBarNotificationConfig;
import com.netease.nimlib.sdk.auth.AuthService;
import com.netease.nimlib.sdk.msg.constant.SessionTypeEnum;
import com.scshuimukeji.share.SMShare;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.xkshop.net.upload.GetMediaManager;
import com.xkshop.net.upload.LocationUtils;
import com.xkshop.promise.BackPressedPromise;
import com.xkshop.promise.ContactPromise;
import com.xkshop.promise.SharePromise;
import com.xkshop.redpoint.RedPointManager;
import com.xkshop.scan.ScanPromiseStore;
import com.xkshop.share.Share;
import com.xkshop.share.ShareBean;
import com.xkshop.util.CaptureManager;
import com.xkshop.util.Utils;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.comm.util.ToastUtil;
import cn.scshuimukeji.database.table.annotations.DefValue;
import cn.scshuimukeji.database.table.im.IMUserInfo;
import cn.scshuimukeji.flow.FlowUtil;
import cn.scshuimukeji.im.core.application.MyMessageObserver;
import cn.scshuimukeji.im.core.application.ROUTER;
import cn.scshuimukeji.im.core.data.service.IMSyncService;
import cn.scshuimukeji.im.core.data.service.MessageTimerService;
import cn.scshuimukeji.im.core.utils.NIMSendMessageUtil;
import cn.scshuimukeji.im.core.utils.clipimage.ClipImageActivity;
import cn.scshuimukeji.im.customer_service.ServiceChatManager;

import static android.app.Activity.RESULT_OK;

public class XKMerchantModule extends ReactContextBaseJavaModule {
    private static final String TAG = "XKMerchantModule";

    /**
     * 系统联系人
     */
    private static final int REQUEST_CONTACT = 0x0001;

    /**
     * 选择可友联系人
     */
    private static final int REQUEST_SELECT_CONTACT = 0x00002;

    public static final String DOWNLOAD_PATH = Environment.getExternalStorageDirectory() + File.separator + "XKMERCHANT" + File.separator + "downloads";

    public static final String APK_FILENAME = "xk_merchant.apk";

    private ReactApplicationContext reactContext;

    public XKMerchantModule(ReactApplicationContext reactContext) {
        super(reactContext);

        this.reactContext = reactContext;

        LoggerUtil.warning("XKMerchantModule-Logger", "XKMerchantModule");

        MainApplication.getInstance().setReactApplicationContext(reactContext);

        reactContext.addActivityEventListener(activityEventListener);

        MyMessageObserver.RNSystemMessageListener systemMessageListener = imMessage -> {
//            ToastUtil.show("新的系统消息");
            XKMerchantEventEmitter.sendSystemMessageToRN(reactContext, imMessage.getAttachment().toJson(false));
        };
        LoggerUtil.info("XKMerchantModuleALis", "register");
        MyMessageObserver.getInstance().setRnSystemMessageListener(systemMessageListener);
    }

    private final ActivityEventListener activityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            if (resultCode == RESULT_OK) {
                switch (requestCode) {
                    //读取通讯录
                    case REQUEST_CONTACT:
                        Uri contactData = Objects.requireNonNull(data).getData();
                        String[] phoneContacts = Utils.getPhoneContacts(reactContext, contactData);
                        if (phoneContacts != null) {
                            WritableMap writableMap = Arguments.createMap();
                            writableMap.putString("name", phoneContacts[0]);
                            writableMap.putString("phoneNumber", phoneContacts[1].replaceAll(" ", "").replaceAll("-", ""));
                            ContactPromise.getInstance().resolve(writableMap);
                        } else {
                            ContactPromise.getInstance().resolve(null);
                        }
                        break;
                    //不需要裁剪，直接返回
                    case CaptureManager.REQUEST_CODE_PHOTO_VIDEO:
                        if (data != null) {
                            String photoPath = data.getStringExtra("result_photo_path");
                            String videoPath = data.getStringExtra("result_video_path");
                            String firstPath = data.getStringExtra("result_video_first_path");
                            WritableArray writableArray = Arguments.createArray();
                            WritableMap writableMap = Arguments.createMap();
                            if (!TextUtils.isEmpty(photoPath)) {
                                writableMap.putString("imagePath", photoPath);
                            } else if (!TextUtils.isEmpty(videoPath)) {
                                writableMap.putString("imagePath", firstPath);
                                writableMap.putString("videoPath", videoPath);
                            }
                            writableArray.pushMap(writableMap);
                            GetMediaManager.getInstance().getPromise().resolve(writableArray);
                        } else {
                            GetMediaManager.getInstance().getPromise().reject("1086", "拍摄失败");
                        }
                        break;

                    //跳转到裁剪页面
                    case CaptureManager.REQUEST_CODE_CAPTURE_NEED_CROP:
                        if (data != null) {
                            String photoPath = data.getStringExtra("result_photo_path");
//                            reactContext.startActivityForResult(CaptureManager.getInstance().getSystemCropIntent(reactContext, photoPath),
//                                    CaptureManager.REQUEST_CODE_CAPTURE_CROP, null);

                            ClipImageActivity.prepare()
                                    .aspectX(1).aspectY(1)
                                    .inputPath(photoPath)
                                    .outputPath(CaptureManager.getInstance().createClipImageFile().getAbsolutePath())
                                    .startForResult(activity, CaptureManager.REQUEST_CODE_CAPTURE_CROP);
                        }
                        break;

                    //裁剪后的图片上传
                    case CaptureManager.REQUEST_CODE_CAPTURE_CROP:
                        File file = CaptureManager.getInstance().getImageClip();
                        if (file != null) {
                            WritableArray writableArray = Arguments.createArray();
                            WritableMap writableMap = Arguments.createMap();
                            writableMap.putString("imagePath", file.getAbsolutePath());
                            writableArray.pushMap(writableMap);
                            GetMediaManager.getInstance().getPromise().resolve(writableArray);
                        } else {
                            GetMediaManager.getInstance().getPromise().reject("1087", "获取图片失败");
                        }
                        break;

                    //选择可友后分享给可友商品/福利
                    case REQUEST_SELECT_CONTACT:
                        List<IMUserInfo> userInfoList = (List<IMUserInfo>) data.getSerializableExtra("data");
                        if (null != userInfoList && userInfoList.size() > 0) {
                            IMUserInfo toUser = userInfoList.get(0);
                            String to = TextUtils.isEmpty(toUser.imId) ? toUser.userId : toUser.imId;
                            ShareBean shareBean = SharePromise.getInstance().getShareBean();
                            if (shareBean == null) {
                                SharePromise.getInstance().reject("101", "failed");
                            } else {
                                if (shareBean.type == 0) {
                                    NIMSendMessageUtil.sendCommodityMessage(
                                            to
                                            , SessionTypeEnum.P2P,
                                            0,
                                            DefValue.MSG_FROM_KY,
                                            shareBean.goodsId,
                                            shareBean.name,
                                            "1",
                                            shareBean.iconUrl,
                                            shareBean.description,
                                            shareBean.price,
                                            "分享给可友",
                                            "",
                                            "",
                                            "",
                                            String.valueOf(MainApplication.getInstance().getRnUserInfo().securityCode),
                                            false);
                                } else {
                                    NIMSendMessageUtil.sendWelfareMessage(
                                            to,
                                            SessionTypeEnum.P2P,
                                            0,
                                            DefValue.MSG_FROM_KY,
                                            shareBean.sequenceId,
                                            shareBean.goodsId,
                                            shareBean.sequenceId,
                                            shareBean.iconUrl,
                                            shareBean.name,
                                            shareBean.description,
                                            shareBean.price,
                                            "分享给可友",
                                            "false",
                                            "false",
                                            "",
                                            false);
                                }
                                SharePromise.getInstance().resolve("success");
                            }
                        } else {
                            SharePromise.getInstance().reject("101", "failed");
                        }
                        break;
                    default:
                        break;
                }
            }
        }

        @Override
        public void onNewIntent(Intent intent) {
        }
    };

    @Override
    public String getName() {
        return "xkMerchantModule";
    }


    /**
     * 选择图片和视频
     * type 选择类型 1:图片 2:视频 3:图片视频混合选择
     * crop 是否需要裁剪 0 不裁剪 1 裁剪
     * total 需要选择的文件数量
     * limit 限制单个上传的文件大小 0 不限制大小 >0 限制大小（单位KB）
     * duration 限制单个上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
     */
    @ReactMethod
    public void pickImageAndVideo(int type, int crop, int totalNum, int limit, int duration, Promise promise) {
        GetMediaManager.getInstance((FragmentActivity) getCurrentActivity()).pickImageAndVideo(type, crop, totalNum, limit, duration, promise);
    }

    /**
     * 拍照或拍视频
     * type 选择类型 0:拍照，1:拍视频，2:既能拍照又能拍视频
     * crop 是否需要裁剪 0:不裁剪 1:裁剪 (仅当type为0时参数生效)
     * duration 限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
     */
    @ReactMethod
    public void takeImageAndVideo(int type, int crop, int duration, Promise promise) {
        GetMediaManager.getInstance((FragmentActivity) getCurrentActivity()).takeImageAndVideo(type, crop, duration, promise);
    }

    //唯一标识
    @ReactMethod
    public void getUniqueIdentifier(final Promise promise) {
        String SerialNumber = android.os.Build.SERIAL;
        promise.resolve(SerialNumber);
    }

    //位置信息
    @ReactMethod
    public void getLocation(Promise promise) {
        new LocationUtils().requireLocation(promise);
    }

    //扫一扫
    @ReactMethod
    public void scanQRCode(Promise promise) {
        ScanPromiseStore.getInstance().scanPromise = promise;
        ARouter.getInstance().build("/scan/common")
                .withInt("operation_flag", 5)
                .withBoolean(Intents.Scan.IS_ONCE, true)
                .navigation();
    }

    /**
     * 打开通讯录
     */
    @ReactMethod
    public void openContact(Promise promise) {
        LoggerUtil.warning("XKMerchantModule", "openContact");
        ContactPromise.getInstance().initPromise(promise);
        Objects.requireNonNull(getCurrentActivity()).runOnUiThread(() -> {
            RxPermissions rxPermissions = new RxPermissions((FragmentActivity) getCurrentActivity());
            rxPermissions.request(Manifest.permission.READ_CONTACTS)
                    .distinct()
                    .subscribe(granted -> {
                        if (granted) {
                            LoggerUtil.warning("XKMerchantModule", "true");
                            Intent contact = new Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI);
                            reactContext.startActivityForResult(contact, REQUEST_CONTACT, null);
                        } else {
                            ContactPromise.getInstance().resolve(null);
                        }
                    });
        });
    }

    /**
     * 跳转到店铺客服
     */
    @ReactMethod
    public void jumpShopService() {
        ARouter.getInstance().build(ROUTER.IM_MERCHANT_CUSTOMER_SERVICE)
                .withString("shopId", MainApplication.getInstance().getShopId())
                .navigation();
    }

    /**
     * 切换店铺
     */
    @ReactMethod
    public void changeShopSuccess(String shopId) {
        LoggerUtil.info("XKMerchantModule", shopId);
        MainApplication.getInstance().setShopId(shopId);
    }

    /**
     * 店铺订单里联系商铺客服
     *
     * @param groupId      群组id
     * @param customerId   用户id
     * @param customerName 用户昵称
     */
    @ReactMethod
    public void createShopCustomerWithCustomerID(String groupId, String customerId, String customerName) {
        ARouter.getInstance().build(ROUTER.IM_MERCHANT_SHOP_SERVICE_CHAT)
                .withString("targetId", groupId)
                .withString("shopId", MainApplication.getInstance().getShopId())
                .withString("customerId", customerId)
                .withString("customerName", customerName)
                .navigation();
    }

    /**
     * 创建平台客服聊天
     */
    @ReactMethod
    public void createXKCustomerSerChat() {
        String teamIcon = "http://gc.xksquare.com/%E5%AE%A2%E6%9C%8D%E5%A4%B4%E5%83%8F@2x.png";
        ServiceChatManager manager = new ServiceChatManager(MainApplication.getInstance().getFragmentActivity());
        manager.contactXKService("商联客服", teamIcon);
    }

    /**
     * 跳转到联盟商群
     */
    @ReactMethod
    public void jumpLocalUnionGroup() {
        ARouter.getInstance().build(ROUTER.IM_MERCHANT_OFFICIAL_GROUP_SESSION).navigation();
    }

    /**
     * APk下载及安装
     *
     * @param url apk下载链接
     */
    @ReactMethod
    public void downloadAndInstall(String url) {
        FileDownloader.setup(MainApplication.getInstance());
        BaseDownloadTask task = FileDownloader.getImpl()
                .create(url)
                .setForceReDownload(true)
                .setPath(DOWNLOAD_PATH + "/" + APK_FILENAME)
                .setListener(new FileDownloadLargeFileListener() {
                    @Override
                    protected void pending(BaseDownloadTask task, long soFarBytes, long totalBytes) {
                        ToastUtil.show("正在下载，请确定您的网络情况良好");
                    }

                    @Override
                    protected void progress(BaseDownloadTask task, long soFarBytes, long totalBytes) {
                        int progress = (int) (soFarBytes * 100 / totalBytes);
                        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("downloadProgress", progress);
                    }

                    @Override
                    protected void paused(BaseDownloadTask task, long soFarBytes, long totalBytes) {
                        ToastUtil.show("下载失败，请确定您的网络情况良好");
                        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("downloadError", 0);
                    }

                    @Override
                    protected void completed(BaseDownloadTask task) {
                        ToastUtil.show("下载完成");
                        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("downloadProgress", 100);
                        Utils.installApk(MainApplication.getInstance(), new File(task.getTargetFilePath()));
                    }

                    @Override
                    protected void error(BaseDownloadTask task, Throwable e) {
                        ToastUtil.show("下载失败，请确定您的网络情况良好");
                        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("downloadError", 0);
                    }

                    @Override
                    protected void warn(BaseDownloadTask task) {
                        ToastUtil.show("下载失败，请确定您的网络情况良好");
                        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("downloadError", 0);
                    }
                });
        task.start();
    }


    /**
     * 打开权限设置页面
     */
    @ReactMethod
    public void openPermissionSettings(Promise promise) {
        Activity currentActivity = getCurrentActivity();

        if (currentActivity == null) {
            promise.reject("Activity不存在");
            return;
        }
        try {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            Uri uri = Uri.fromParts("package", getReactApplicationContext().getPackageName(), null);
            intent.setData(uri);
            currentActivity.startActivity(intent);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e.getMessage());
        }
    }

    /**
     * 商联登录成功，跳转登录IM
     *
     * @param userInfo  用户信息
     * @param autoLogin 是否自动登录
     */
    @ReactMethod
    public void loginSuccess(ReadableMap userInfo, Boolean autoLogin) {
        MainApplication.getInstance().setLoginInfo(userInfo);
        ReadableNativeMap map = (ReadableNativeMap) userInfo;
        HashMap userInfoMap = map.toHashMap();

        String userJson = new Gson().toJson(userInfoMap);
        ARouter.getInstance()
                .build("/merchant/login")
                .withString("userJson", userJson)
                .withBoolean("needLoginIM", true)
                .navigation();
    }

    /**
     * 更新个人信息
     *
     * @param userInfo 个人信息
     */
    @ReactMethod
    public void updateUser(ReadableMap userInfo) {
        ReadableNativeMap map = (ReadableNativeMap) userInfo;
        HashMap userInfoMap = map.toHashMap();
        String userJson = new Gson().toJson(userInfoMap);
        ARouter.getInstance()
                .build("/merchant/login")
                .withString("userJson", userJson)
                .withBoolean("needLoginIM", false)
                .navigation();
    }

    /**
     * 退出登录
     *
     * @param userInfo 个人信息
     */
    @ReactMethod
    public void loginOut(ReadableMap userInfo) {
        //清空用户信息缓存
        FlowUtil.clearUserCache();
        //云信退出登录
        NIMClient.getService(AuthService.class).logout();
    }

    @ReactMethod
    public void clickFriendScreen() {
//        ARouter.getInstance().build("/merchant/friend").navigation();
//        Intent intent = new Intent(getCurrentActivity(), FriendActivity.class);
//        MainApplication.getInstance().getFragmentActivity().startActivity(intent);
//        getCurrentActivity().overridePendingTransition(R.anim.fade_in, 0);
    }

    /**
     * 分享商品或福利给可友
     *
     * @param infoJson 分享消息详情json字符串
     */
    @ReactMethod
    public void shareToKYFriend(String infoJson, Promise promise) {
        ShareBean shareBean = new Gson().fromJson(infoJson, ShareBean.class);
        SharePromise.getInstance().initPromise(promise, shareBean);

        ARouter.getInstance().build(ROUTER.IM_MERCHANT_SELECT_CONTACT)
                .withInt("max", 1)
                .withString("rightText", "确定")
                .withBoolean("isBack", true)
                .navigation(getCurrentActivity(), REQUEST_SELECT_CONTACT);
    }

    /**
     * 调用分享
     *
     * @param type    分享平台类型
     * @param url     分享链接
     * @param title   分享标题
     * @param info    分享内容
     * @param iconUrl 分享缩略图
     * @param promise 回调
     */
    @ReactMethod
    public void share(String type, String url, String title, String info, String iconUrl, Promise promise) {
        SMShare.TYPE typeX;
        switch (type) {
            case "QQ":
                typeX = SMShare.TYPE.QQ;
                break;
            case "WB":
                typeX = SMShare.TYPE.WB;
                break;
            case "WX":
                typeX = SMShare.TYPE.WX;
                break;
            case "QQ_Z":
                typeX = SMShare.TYPE.QQ_Z;
                break;
            case "WX_P":
                typeX = SMShare.TYPE.WX_P;
                break;
            default:
                typeX = SMShare.TYPE.WX;
                break;
        }
        Objects.requireNonNull(getCurrentActivity()).runOnUiThread(() -> Share.share(getCurrentActivity(), typeX, url, title, info, iconUrl, promise));
    }

    /**
     * 跳转到应用设置通知界面
     */
    @ReactMethod
    public void jumpToAppNotificationSetting() {
        Intent intent = new Intent();
        //android 8.0引导
        if (Build.VERSION.SDK_INT >= 26) {
            intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
            intent.putExtra("android.provider.extra.APP_PACKAGE", getCurrentActivity().getPackageName());
        }
        //android 5.0-7.0
        if (Build.VERSION.SDK_INT >= 21 && Build.VERSION.SDK_INT < 26) {
            intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
            intent.putExtra("app_package", getCurrentActivity().getPackageName());
            intent.putExtra("app_uid", getCurrentActivity().getApplicationInfo().uid);
        }
        //其他
        if (Build.VERSION.SDK_INT < 21) {
            intent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
            intent.setData(Uri.fromParts("package", getCurrentActivity().getPackageName(), null));
        }
        getCurrentActivity().startActivity(intent);
    }

    /**
     * 跳转至可友个人中心
     *
     * @param userId 用户id
     */
    @ReactMethod
    public void jumpPersonalCenter(String userId) {
        ARouter.getInstance().build(ROUTER.IM_MERCHANT_FRIEND_INFO).withString("userId", userId).navigation();
    }

    /**
     * 物理返回键监听
     */
    @ReactMethod
    public void onBackPressed(Promise promise) {
        BackPressedPromise.getInstance().initPromise(promise);
    }

    /**
     * 关闭商品/福利详情activity，返回MainActivity
     */
    @ReactMethod
    public void popToNative() {
        if (getCurrentActivity() != null) {
            getCurrentActivity().finish();
        }
    }

    /**
     * 同步个人信息
     */
    @ReactMethod
    public void syncUserInfo(String userId) {
        if (!TextUtils.isEmpty(userId)) {
            IMSyncService imSyncService = new IMSyncService();
            imSyncService.syncUserZip(userId);
        }
    }

    /**
     * 返回最新红点信息
     *
     * @param promise
     */
    @ReactMethod
    void getRedPointStatus(Promise promise) {
        WritableMap map = Arguments.createMap();
        map.putString("union", RedPointManager.getInstance().isHasUnionMsg() ? "1" : "0");
        map.putString("friend", RedPointManager.getInstance().isHasMainMsg() ? "1" : "0");
        map.putString("xkSer", RedPointManager.getInstance().isHasXKMsg() ? "1" : "0");
        map.putString("shopSer", RedPointManager.getInstance().isHasShopMsg() ? "1" : "0");
        promise.resolve(map);
    }

    /**
     * 开关IM消息通知声音
     *
     * @param flag 整数类型 0 开启静音 1关闭静音
     */
    @ReactMethod
    public void switchIMMute(int flag) {
        StatusBarNotificationConfig config = SDKOptions.DEFAULT.statusBarNotificationConfig;
        config.ring = flag == 1;
        NIMClient.updateStatusBarNotificationConfig(config);
    }

    /**
     * 获取IM消息通知声音状态
     * flag 整数类型 0 开启静音 1关闭静音
     *
     * @param promise 回调
     */
    @ReactMethod
    public void getIMMute(Promise promise) {
        StatusBarNotificationConfig config = SDKOptions.DEFAULT.statusBarNotificationConfig;
        //如果找到配置，则返回配置，否则默认返回无铃声
        if (config != null) {
            promise.resolve(config.ring ? 1 : 0);
        } else {
            promise.resolve(0);
        }
    }

    /**
     * 是否接受可友消息推送开关
     *
     * @param flag 1：打开，0关闭
     */
    @ReactMethod
    public void onSwitchFriendMsg(int flag) {
        NIMClient.toggleNotification(flag == 1);
        //免打扰开关设置
        StatusBarNotificationConfig config = SDKOptions.DEFAULT.statusBarNotificationConfig;
        config.downTimeToggle = flag == 0;
        NIMClient.updateStatusBarNotificationConfig(config);
    }


    /**
     * 获取消息推送开关状态
     * 1 打开推送 0 关闭推送
     */
    @ReactMethod
    public void getFriendMsgSwitch(Promise promise) {
        StatusBarNotificationConfig config = SDKOptions.DEFAULT.statusBarNotificationConfig;
        if (config != null) {
            promise.resolve(config.downTimeToggle ? 0 : 1);
        } else {
            promise.resolve(1);
        }
    }

    /**
     * 获取密友时间戳
     */
    @ReactMethod
    public void secreteMessageTimer() {
        new MessageTimerService().messageTimer();
    }

}
