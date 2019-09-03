package com.xkshop.wxapi;

import android.app.Activity;
import androidx.lifecycle.Lifecycle;
import android.os.Bundle;
import android.os.PersistableBundle;
import androidx.annotation.Nullable;

import com.orhanobut.logger.Logger;
import com.scshuimukeji.login.logincore.api.LoginRequest;
import com.scshuimukeji.login.logincore.api.application.LoginConfig;
import com.scshuimukeji.login.logincore.api.application.LoginContans;
import com.scshuimukeji.login.logincore.api.utils.LoginUtil;
import com.scshuimukeji.share.SMShare;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.xkshop.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import cn.scshuimukeji.comm.net.HttpClient;
import cn.scshuimukeji.comm.util.ToastUtil;
import cn.scshuimukeji.database.table.im.IMUserInfo;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Request;


public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

    private Lifecycle.State state;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_im_login);
        try {
            SMShare.iwxapi.handleIntent(getIntent(), this);
        } catch (Exception e) {
            e.printStackTrace();
            ToastUtil.show("微信调起失败");
            finish();
        }
    }

    // 微信发送请求到第三方应用时，会回调到该方法
    @Override
    public void onReq(BaseReq req) {
        switch (req.getType()) {
            case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
//                goToGetMsg();
                break;
            case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
                //goToShowMsg((ShowMessageFromWX.Req) req);
                break;
            default:
                break;
        }
    }

    // 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
    @Override
    public void onResp(BaseResp resp) {
        String result;

        switch (resp.errCode) {
            case BaseResp.ErrCode.ERR_OK:
                result = "操作成功";
                break;
            case BaseResp.ErrCode.ERR_USER_CANCEL:
                result = "操作取消";
                break;
            case BaseResp.ErrCode.ERR_SENT_FAILED:
                result = "操作失败";
                break;
            case BaseResp.ErrCode.ERR_AUTH_DENIED:
                result = "拒绝授权";
                break;
            case BaseResp.ErrCode.ERR_UNSUPPORT:
                result = "不支持";
                break;
            case BaseResp.ErrCode.ERR_BAN:
                result = "签名不正确";
                break;
            default:
                result = "未知错误";
                break;
        }

        if (resp.errCode != BaseResp.ErrCode.ERR_OK) {
            ToastUtil.show(result + resp.errCode);
            finish();
            return;
        }
        if (resp instanceof SendAuth.Resp) {
            try {
                getUser((SendAuth.Resp) resp);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else if (resp instanceof SendMessageToWX.Resp) {
            SendMessageToWX.Resp resp1 = (SendMessageToWX.Resp) resp;
            Logger.e(resp1.toString());
            if (SMShare.shareCallBackListener != null) {
                if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                    SMShare.shareCallBackListener.success();
                } else {
                    SMShare.shareCallBackListener.fail("分享失败：" + resp.errStr);
                }
            }
            finish();
        }
    }

    private void getUser(SendAuth.Resp resp) throws IOException {
        SendAuth.Resp resp1 = resp;
        String url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + SMShare.wxAppKey
                + "&secret=" + LoginConfig.wxAppSecret//5306a2d06c926e6134d2ee9777d93539
                + "&code=" + resp1.code
                + "&grant_type=authorization_code";

        Request request = new Request.Builder()
                .url(url)
                .get()//默认就是GET请求，可以不写
                .build();
        Call call = HttpClient.getInstance().getOkHttpClient().newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                e.printStackTrace();
                ToastUtil.show("getUser失败，请查看日志");
                finish();
            }

            @Override
            public void onResponse(Call call, okhttp3.Response response) throws IOException {
                String res = response.body().string();
                JSONObject jsonObject = null;
                try {
                    jsonObject = new JSONObject(res);
                    String token = jsonObject.optString("access_token");
                    String id = jsonObject.optString("openid");
                    getUserInfo(token, id);
                } catch (JSONException e) {
                    e.printStackTrace();
                    ToastUtil.show("getUser错误，请查看日志");
                    finish();
                }
            }
        });
    }

    private void getUserInfo(String token, String openid) {
        String url = "https://api.weixin.qq.com/sns/userinfo?access_token="
                + token + "&openid=" + openid;
        Request request = new Request.Builder()
                .url(url)
                .get()//默认就是GET请求，可以不写
                .build();
        Call call = HttpClient.getInstance().getOkHttpClient().newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                e.printStackTrace();
                ToastUtil.show("getUserInfo失败，请查看日志");
                finish();
            }

            @Override
            public void onResponse(Call call, okhttp3.Response response) throws IOException {
                String res = response.body().string();
                JSONObject jsonObject = null;
                try {
                    jsonObject = new JSONObject(res);
                    String unionid = jsonObject.optString("unionid");
                    String openid = jsonObject.optString("openid");
                    String avatar = jsonObject.optString("headimgurl");
                    String nickname = jsonObject.optString("nickname");
                    int sex = jsonObject.optInt("sex");

                    LoginRequest request = new LoginRequest();
                    request.unionid = unionid;
                    request.avatar = avatar;
                    request.nickname = nickname;
                    request.openid = openid;
                    request.sex = String.valueOf(sex);

                    login(unionid, openid, avatar, nickname, sex);
                } catch (JSONException e) {
                    e.printStackTrace();
                    ToastUtil.show("getUserInfo错误，请查看日志");
                    finish();
                }
            }

        });
    }

    private void login(String unionid, String openid, String avatar, String nickname, int sex) {
//        viewModel.loginByThird(unionid, openid, avatar, nickname, String.valueOf(sex), new XKSLObserver<IMUserInfo>() {
//            @Override
//            public void success(IMUserInfo response) throws Exception {
//                loginSuccess(response);
//            }
//
//            @Override
//            public void error(String message) throws Exception {
//                ToastUtil.show(message);
//                finish();
//            }
//        });
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        state = Lifecycle.State.CREATED;
    }

    @Override
    protected void onStart() {
        super.onStart();
        state = Lifecycle.State.STARTED;
    }

    @Override
    protected void onResume() {
        super.onResume();
        state = Lifecycle.State.RESUMED;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        state = Lifecycle.State.DESTROYED;
    }

    private void loginSuccess(IMUserInfo response) {
        if (response == null) {
            ToastUtil.show("登录失败");
            finish();
            return;
        }
        response.accountId = response.userId;
        response.loginStatus = LoginContans.STATUS.LOGGED;
        response.updateTime = System.currentTimeMillis();

        LoginUtil.loginSuccess(this, response);
    }
}
