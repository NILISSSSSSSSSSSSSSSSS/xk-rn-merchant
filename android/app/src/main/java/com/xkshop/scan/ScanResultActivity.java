package com.xkshop.scan;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.google.zxing.client.android.Intents;

import java.net.MalformedURLException;
import java.util.Map;

import cn.scshuimukeji.comm.CommActivity;
import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.comm.util.ToastUtil;
import cn.scshuimukeji.im.core.application.ROUTER;

/**
 * @Describe 扫一扫结果中转
 * @Author 鲍立志
 */

@Route(path = "/base/scan")
public class ScanResultActivity extends CommActivity {

    private String opData;
    private int opFlag;

    /**
     * 商家扫码客户消费码
     */
    public static final int OPERATION_FLAG_CONSUMER_CODE = 5;

    /**
     * IM主页扫一扫
     **/
    public static final int OPERATION_FLAG_IM_HOME_CODE = 7;

    /**
     * IM 添加可友页[扫一扫添加]
     **/
    public static final int OPERATION_FLAG_IM_ADD_FRIEND_CODE = 8;

    /**
     * IM 添加密友页[扫一扫添加]
     **/
    public static final int OPERATION_FLAG_IM_SECRET_FRIEND_CODE = 10;

    @Override
    public int onViewLayout() {
        return 0;
    }

    @Override
    public void onViewCreate(View view) {
        Uri uri = getIntent().getData();
        String result = getIntent().getStringExtra(CONSTRAINT.GLOBAL.SCAN_RESULT_KEY);
        LoggerUtil.info("ScanResultActivity", result);

        if (null != ScanPromiseStore.getInstance().scanPromise) {
            ScanPromiseStore.getInstance().scanPromise.resolve(result);
            finish();
        } else {
            opData = getIntent().getStringExtra(Intents.Scan.OPERATION_DATA);      // 可以传递业务数据
            opFlag = getIntent().getIntExtra(Intents.Scan.OPERATION_FLAG, 0);         // 这里默认为0，所以不要拿0做flag
            merchantFriendScan(result);
            finish();
        }
    }

    /***
     * 可友扫码处理
     * @param result 二维码文本信息
     */
    private void merchantFriendScan(String result) {
        try {
            SMURL url = new SMURL(result);
            String protocol = url.getProtocol();
            if ("http".equals(protocol) || "https".equals(protocol)) {
                //H5
                String content = url.getQuery();
                int start = content.indexOf("&QRCode=");
                if (start == -1) {
                    //纯网页
                    openWebBrowser(this, result);
                    return;
                }
                //纯网址 + 二维码信息
                String qrcodeStr = content.substring(start + 8);
                parseQrcod(qrcodeStr);
            } else {
                //纯二维码信息
                parseQrcod(result);
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }

    }

    private void parseQrcod(String content) throws MalformedURLException {
        SMURL url = new SMURL(content);
        String protocol = url.getProtocol();
        switch (protocol) {
            case CONSTRAINT.QRCODE.PROTOCOL_XKGC:
                //晓可广场二维码
                parseXkSL(url, true);
                break;
            case CONSTRAINT.QRCODE.PROTOCOL_XKSL:
                //晓可商联二维码
                parseXkSL(url, false);
                break;
        }
    }

    private void parseXkSL(SMURL url, boolean isXkgc) {
        String host = url.getHost();
        switch (host) {
            case CONSTRAINT.QRCODE.HOST_XK_FRIENDS_HOME:
                //可友主页
                toUserHome(url.getQuery());
                break;
            case CONSTRAINT.QRCODE.HOST_XK_GROUP_CHAT:
                //可友群聊
                if (!isXkgc) {
                    toXkGroupChat(url);
                } else {
                    ToastUtil.show("请用晓可广场App查看");
                }
                break;
//            case CONSTRAINT.QRCODE.OFFLINE_CONSUMPTION_ORDER:
//                LoggerUtil.info("ScanResultActivity", url.getParams().toString());
//                break;
            default:
                LoggerUtil.info("ScanResultActivity", url.getParams().toString());
                break;
        }
    }

    /**
     * 可友主页
     *
     * @param result
     */
    private void toUserHome(String result) {
        String subStr = "userId=";
        String uidStr = result.substring(result.indexOf(subStr) + subStr.length());
        if (uidStr.contains("&")) {
            String id = uidStr.substring(0, uidStr.indexOf("&"));
            ARouter.getInstance().build(ROUTER.IM_MERCHANT_FRIEND_INFO)
                .withString("secretlyId", opData)
                .withString("userId", id)
                .navigation();
        } else {
            ARouter.getInstance().build(ROUTER.IM_MERCHANT_FRIEND_INFO)
                .withString("secretlyId", opData)
                .withString("userId", uidStr)
                .navigation();
        }

    }

    /***
     * 可友群聊
     * @param smurl
     */
    private void toXkGroupChat(SMURL smurl) {
        Map<String, String> params = smurl.getParams();
        String groupId = params.get(CONSTRAINT.QRCODE.PARAMS_KEY_GROUPID);//群id
        ARouter.getInstance()
            .build(ROUTER.IM_MERCHANT_ADD_GROUP)
            .withString("groupId", groupId)
            .navigation();
    }


    /***
     *打开外部浏览器
     *@paramcontext上下文
     *@paramurl网址
     */
    public static void openWebBrowser(Context context, String url) {
        final Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(url));
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            context.startActivity(Intent.createChooser(intent, "请选择浏览器"));
        } else {
            ToastUtil.show("手机未找到浏览器");
        }
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
    public void onStateResume(Bundle state) {

    }
}
