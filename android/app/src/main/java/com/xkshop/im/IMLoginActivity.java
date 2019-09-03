package com.xkshop.im;

import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.View;

import com.alibaba.android.arouter.facade.annotation.Autowired;
import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.google.gson.Gson;
import com.xkshop.MainApplication;

import cn.scshuimukeji.comm.CommActivity;
import cn.scshuimukeji.comm.CommApplication;
import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.database.XKDBClient;
import cn.scshuimukeji.database.table.annotations.DefValue;
import cn.scshuimukeji.database.table.im.IMUserInfo;
import cn.scshuimukeji.database.table.im.YXUserInfo;
import cn.scshuimukeji.flow.FlowUtil;
import cn.scshuimukeji.im.core.application.IMCallback;
import cn.scshuimukeji.im.core.data.repository.IMLoginRepository;
import cn.scshuimukeji.im.core.data.repository.impl.IMLoginRepositoryImpl;
import io.reactivex.Observable;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/1/19 12:43
 * Desc:   1dp大小 activity 登录商联IM，登录成功后finish掉这个activity
 */
@Route(path = "/merchant/login")
public class IMLoginActivity extends CommActivity {

    /**
     * IM 登陆知识库.
     */
    private IMLoginRepository imLoginRepository = new IMLoginRepositoryImpl();

    //RN传过来的登录信息
    @Autowired(name = "userJson")
    public String userJson;

    //是否需要登录IM
    @Autowired(name = "needLoginIM")
    public boolean needLoginIM;

    //解析RN传入的登录信息得到的实体
    private RNUserInfo rnUserInfo;

    @Override
    public int onViewLayout() {
        return 0;
    }

    @Override
    public void onViewCreate(View view) {

        ARouter.getInstance().inject(this);
        rnUserInfo = new Gson().fromJson(userJson, RNUserInfo.class);
        MainApplication.getInstance().setRnUserInfo(rnUserInfo);

        loginIm();

        LoggerUtil.warning("IMLoginActivity-Logger", "onViewCreate");

    }

    /**
     * 登录im
     */
    public void loginIm() {
        Observable.create((ObservableOnSubscribe<IMUserInfo>) emitter -> {
            IMUserInfo userInfo = new IMUserInfo();
            userInfo.userId = rnUserInfo.id;
//                    userInfo.numberId =
//                    userInfo.friendBirthday =
//                    userInfo.friendSignature = .
//                    userInfo.address =
//                    userInfo.friendSex =
//                    userInfo.authStatus =
            userInfo.securityCode = String.valueOf(rnUserInfo.securityCode);
            userInfo.friendAvatar = rnUserInfo.avatar;
            userInfo.token = rnUserInfo.token;
            LoggerUtil.info("IMLoginActivity", "token:" + rnUserInfo.token);
//                    userInfo.friendConstellation =
            userInfo.businessCard = rnUserInfo.qrCode;
            userInfo.phoneNumber = rnUserInfo.phone;
            userInfo.friendNickname = rnUserInfo.nickName;
//                    userInfo.friendNicknamePinYin =
//                    userInfo.friendAge =
//                    userInfo.zbConsumption =
//                    userInfo.zbIncome =
            YXUserInfo yxUserInfo = new YXUserInfo();
            yxUserInfo.yxId = rnUserInfo.userImAccount.accid;
            yxUserInfo.yxToken = rnUserInfo.userImAccount.token;
            userInfo.yxUserInfo = yxUserInfo;

            // 补充本地必须的数据.
            userInfo.accountId = rnUserInfo.id;
            userInfo.loginStatus = DefValue.LOGIN_STATUS_LOGGED;
            userInfo.updateTime = System.currentTimeMillis();
            // 补充字段
            userInfo.imId = yxUserInfo.yxId;

            // 入库
            XKDBClient.getInstance()
                .open(CommApplication.getInstance(), "XKDB")
                .userInfoDao()
                .insert(userInfo);
            // 更新 Flow 内存信息
            FlowUtil.saveUser(userInfo);
            if (needLoginIM) {
                emitter.onNext(userInfo);
            } else {
                emitter.onComplete();
            }
        })
            .flatMap((Function<IMUserInfo, Observable<IMCallback>>)
                data -> Observable.create(emitter -> {
                    imLoginRepository.doLogin(IMLoginActivity.this, data.userId, data.yxUserInfo.yxId, data.yxUserInfo.yxToken)
                        .observe(IMLoginActivity.this, imCallback -> {
                            emitter.onNext(imCallback);
                            if (null != imCallback && imCallback.code == 200) {
                                emitter.onComplete();
                            }
                        });
                }))
            .subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(new Observer<IMCallback>() {
                @Override
                public void onSubscribe(Disposable d) {

                }

                @Override
                public void onNext(IMCallback imCallback) {
                    LoggerUtil.info("IMLoginActivity", "IMLoginActivity finish");
                    finish();
                }

                @Override
                public void onError(Throwable e) {
                    LoggerUtil.info("IMLoginActivity", "IMLoginActivity finish");
                    finish();
                }

                @Override
                public void onComplete() {
                    LoggerUtil.info("IMLoginActivity", "IMLoginActivity finish");
                    finish();
                }
            });
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
