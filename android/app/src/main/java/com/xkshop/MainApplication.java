package com.xkshop;

import android.app.Activity;
import android.util.ArrayMap;
import android.util.DisplayMetrics;

import androidx.fragment.app.FragmentActivity;

import com.alibaba.android.arouter.launcher.ARouter;
import com.facebook.react.PackageList;
import com.facebook.react.ReactApplication;
import com.reactnativecommunity.cameraroll.CameraRollPackage;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.soloader.SoLoader;
import com.masteratul.exceptionhandler.ReactNativeExceptionHandlerModule;
import com.orhanobut.logger.Logger;
import com.scshuimukeji.login.logincore.api.application.LoginApplicationListener;
import com.scshuimukeji.login.logincore.api.application.LoginConfig;
import com.scshuimukeji.login.logincore.api.application.LoginContans;
import com.umeng.commonsdk.UMConfigure;
import com.xkshop.alipay.AlipayPackage;
import com.xkshop.im.IMNotificationActivity;
import com.xkshop.im.RNUserInfo;
import com.xkshop.im.RequestConfig;
import com.xkshop.invokenative.DplusReactPackage;
import com.xkshop.invokenative.RNUMConfigure;
import com.xkshop.scan.CONSTRAINT;
import com.xkshop.util.FileUtils;
import com.xkshop.util.XKSLObserver;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import cn.scshuimukeji.comm.CommApplication;
import cn.scshuimukeji.comm.beans.http.BaseUrl;
import cn.scshuimukeji.comm.client.ActivityStackClient;
import cn.scshuimukeji.comm.configs.ApplicationConfig;
import cn.scshuimukeji.comm.configs.NetworkConfig;
import cn.scshuimukeji.comm.lifecycles.ApplicationListener;
import cn.scshuimukeji.comm.net.interceptors.BaseUrlInterceptor;
import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.comm.util.SensitiveWordUtil;
import cn.scshuimukeji.comm.util.ToastUtil;
import cn.scshuimukeji.database.XKDBClient;
import cn.scshuimukeji.database.table.im.IMUserInfo;
import cn.scshuimukeji.flow.FlowApplicationListener;
import cn.scshuimukeji.flow.FlowConfig;
import cn.scshuimukeji.flow.FlowUtil;
import cn.scshuimukeji.im.core.application.IMApplicationListener;
import cn.scshuimukeji.im.core.application.IMConfig;
import cn.scshuimukeji.im.core.application.ROUTER;
import cn.scshuimukeji.immerchant.IMMerchantStyleConfig;
import cn.scshuimukeji.scan.ScanApplicationListener;
import cn.scshuimukeji.scan.ScanConfig;
import io.reactivex.Observable;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;


public class MainApplication extends CommApplication implements ReactApplication {


    /**
     * rn主界面
     */
    private FragmentActivity fragmentActivity;

    public FragmentActivity getFragmentActivity() {
        return fragmentActivity;
    }

    public void setFragmentActivity(FragmentActivity fragmentActivity) {
        this.fragmentActivity = fragmentActivity;
    }

    /**
     * rn登录信息
     */
    private RNUserInfo rnUserInfo;

    public RNUserInfo getRnUserInfo() {
        return rnUserInfo;
    }

    public void setRnUserInfo(RNUserInfo rnUserInfo) {
        this.rnUserInfo = rnUserInfo;
    }

    private ReadableMap loginInfo;

    public ReadableMap getLoginInfo() {
        return loginInfo;
    }

    public void setLoginInfo(ReadableMap loginInfo) {
        this.loginInfo = loginInfo;
    }

    /**
     * rn传递的店铺id
     */
    private String shopId;

    public String getShopId() {
        return shopId;
    }

    public void setShopId(String shopId) {
        this.shopId = shopId;
    }

    private ReactApplicationContext reactApplicationContext;

    public ReactApplicationContext getReactApplicationContext() {
        return reactApplicationContext;
    }

    public void setReactApplicationContext(ReactApplicationContext reactApplicationContext) {
        this.reactApplicationContext = reactApplicationContext;
    }

    private static MainApplication mainApplication;

    /**
     * 获取应用程序 Application 实例.
     *
     * @return 返回应用程序 Application 实例.
     */
    public static MainApplication getInstance() {
        return mainApplication;
    }

    private RequestConfig envir;


    /**
     * App 生命周期回调接口.
     * 用于实现第三方接入.
     */
    private List<ApplicationListener> listeners = new ArrayList<>();

    // 设置为 true 将不会弹出 toast
    private boolean SHUTDOWN_TOAST = true;
    // 设置为 true 将不会打印 log
    private boolean SHUTDOWN_LOG = false;
    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
        @Override
        public boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            @SuppressWarnings("UnnecessaryLocalVariable")
            List<ReactPackage> packages = new PackageList(this).getPackages();
            // Packages that cannot be autolinked yet can be added manually here, for example:
            // packages.add(new MyReactNativePackage());
            packages.add(new XKMerchantPackage());
            packages.add(new DplusReactPackage());
            packages.add(new AlipayPackage());
            return packages;
        }

        @Override
        protected String getJSMainModuleName() {
            return "index";
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    @Override
    public void onCreate() {
        envir = FileUtils.getRequestConfig(this, "requestConfig.json");
        super.onCreate();
        SoLoader.init(this, /* native exopackage */ false);
        ARouter.init(this);
        if (BuildConfig.DEBUG) {
            ARouter.openLog();
        }
        mainApplication = this;
        //初始化组件化基础库, 统计SDK/推送SDK/分享SDK都必须调用此初始化接口
        RNUMConfigure.init(this, "5bf290a6b465f54b88000076", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "");
//        initScan();

        LoggerUtil.warning("MainApplication-Logger", "onCreate");

        DisplayMetrics displayMetrics = this.getResources().getDisplayMetrics();
        if (displayMetrics.scaledDensity != displayMetrics.density) {
            LoggerUtil.warning("MainApplication-Logger", "字体缩放比例因子被修改了");
            displayMetrics.scaledDensity = displayMetrics.density;
        }

        ReactNativeExceptionHandlerModule.replaceErrorScreenActivityClass(ErrorScreenActivity.class);

        SensitiveWordUtil.init(getApplicationContext(), "CensorWords.txt", "CensorWords_LIVE.txt");
    }

    @Override
    public List<ApplicationListener> getApplicationCallbacks() {
        //////////////////////////////
        ////////// 清空数据源
        //////////////////////////////

        listeners.clear();

        //////////////////////////////
        ////////// [SCAN] 扫一扫
        //////////////////////////////

        listeners.add(new ScanApplicationListener(
                new ScanConfig()
                        .setResultActivity(CONSTRAINT.GLOBAL.ROUTER_CHROME_HOME + CONSTRAINT.PATH.BASE.BASE_SCAN_RESULT_ACT)
                        .setSelectPictureActivity("/comm/gallery")
                        .setMyQrCodeActivity(ROUTER.IM_MERCHANT_MY_QRCODE)
                        .setResultKey(CONSTRAINT.GLOBAL.SCAN_RESULT_KEY)));

        //////////////////////////////
        ////////// [IM] 即时通讯
        //////////////////////////////

        listeners.add(new IMApplicationListener(new IMConfig()
                /**
                 * 此处切换商联H5环境
                 */
                .setH5BaseUrl(FileUtils.getH5URL(envir))
                .setPlatformKey("ma")
                .setMerchantType(true)
                .setNotificationActivity(IMNotificationActivity.class)  // 注册通知栏点击响应activity
                .setAppKey("abe7a770f36b0621d05426343363baa5")
                .setImStyleConfig(new IMMerchantStyleConfig())
                .setAppPackageName("com.xkshop")                        // 包名
                .setXmAppId("2882303761517943529")                      // 小米appid
                .setXmAppKey("5861794390529")                           // 小米appkey
                .setXmCertificateName("XKMerchantXM")                   // 云信小米证书名
                .setMzAppId("118635")                                   // 魅族appid
                .setMzAppKey("258fa68a3e3447ce8956de87d8b1b5c4")        // 魅族appkey
                .setMzCertificateName("XKMerchantMZ")                   // 云信魅族证书名
                .setHwCertificateName("XKMerchantHW")                   // 云信华为证书名
                .setScanUrl(CONSTRAINT.GLOBAL.ROUTER_CHROME_HOME + "/scan/common")
                .setPlayerRouterPath("/rn/player")
                .setListener((code, message) -> Logger.t("BaseApplication").e("IM Event : " + code + " >>>> " + message))
        ));

        //////////////////////////////
        ////////// [Flow] 网络请求流处理
        //////////////////////////////

        listeners.add(new FlowApplicationListener(new FlowConfig()
                .setSignKey("e10adc3949ba59abbe56e057f20f883e")
                .setEncryptionKey("c33367701511b4f6020ec61ded352059")
                .setFlowEventListener((code, message) -> {
                    if (413 == code || 1413 == code || 1349 == code || 1356 == code) {
                        // token失效 重新登录
                        Observable.create((ObservableOnSubscribe<String>) emitter -> {
                            IMUserInfo userInfo = FlowUtil.getUser();
                            userInfo.loginStatus = LoginContans.STATUS.LOGGED_OUT;
                            userInfo.updateTime = System.currentTimeMillis();
                            XKDBClient.getInstance().opened().userInfoDao().insert(userInfo);
                            emitter.onNext("1");
                        }).subscribeOn(Schedulers.io())
                                .observeOn(AndroidSchedulers.mainThread())
                                .subscribe(new XKSLObserver<String>() {
                                    @Override
                                    public void success(String response) {
                                        Activity activity = ActivityStackClient.getInstance().getTopActivity();
                                        if (activity != null) {
                                            ActivityStackClient.getInstance().clearBottom(activity);
                                            ActivityStackClient.getInstance().clear();
                                        }
                                        XKMerchantEventEmitter.sendLoginTokenFail(reactApplicationContext, String.valueOf(code), message);
                                    }

                                    @Override
                                    public void error(String message) {
                                        ToastUtil.show(message);
                                    }
                                });
                    }
                })
        ));


        listeners.add(new LoginApplicationListener(new LoginConfig()
                .setContext(getApplicationContext())
                .setQqkey("1107815223")
                .setWxkey("wx469f90e31aa7c9d8") //wx469f90e31aa7c9d8
                .setWxAppSecret("vk8o78owuy51hui6lmnv3vsinkihtt3i") //094381ad7a66ee5846b6ba610371f36b
                .setWbkey("2327109240")
                .setWbUrl("http://www.sina.com")
                .setWbScope("email,direct_messages_read,direct_messages_write,invitation_write")
                .setHomePath("/react/home")));
        return listeners;
    }

    @Override
    public ApplicationConfig getApplicationConfig() {

        //////////////////////////////
        ////////// 网络日志
        //////////////////////////////

        // 初始化 OkHttp 网络日志拦截器
        HttpLoggingInterceptor httpLoggingInterceptor = new HttpLoggingInterceptor();
        // 设置日志级别
        httpLoggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY);

        //////////////////////////////
        ////////// 多域名配置
        //////////////////////////////

        // 初始化多域名配置
        Map<String, BaseUrl> urlMaps = new ArrayMap<>();

        //////////////////////////////
        ////////// 应用程序配置
        //////////////////////////////

        // 初始化应用程序配置信息
        ApplicationConfig config = new ApplicationConfig();

        //////////////////////////////
        ////////// 调试模式
        //////////////////////////////

        // 开启调试模式,若未开启,则不会打印日志信息.
        config.setDebugModel(true);

        //////////////////////////////
        ////////// 网络请求客户端
        //////////////////////////////

        // 设置 HttpClient 配置信息,用于发起网络请求,主要是接口请求.
        config.setHttpClientConfig(new NetworkConfig() {

            /**
             * 获取网络底层客户端构造器.
             *
             * @return 网络底层客户端构造器.
             */
            @Override
            public OkHttpClient.Builder getOkBuilder() {
                // 添加网络拦截器,用于打印网络请求日志
                return new OkHttpClient.Builder()
                        .connectTimeout(10, TimeUnit.SECONDS)
                        .readTimeout(10, TimeUnit.SECONDS)
                        .writeTimeout(10, TimeUnit.SECONDS)
                        .addInterceptor(httpLoggingInterceptor)
                        .addInterceptor(new BaseUrlInterceptor(urlMaps));
            }

            /**
             * 获取网络 API 层客户端构造器.
             *
             * @return 网络 API 层客户端构造器.
             */
            @Override
            public Retrofit.Builder getReBuilder() {
                return new Retrofit.Builder()
                        /**
                         * 此处切换商联接口环境
                         */
                        .baseUrl(FileUtils.getBaseURL(envir))
                        .addConverterFactory(GsonConverterFactory.create())
                        .addCallAdapterFactory(RxJava2CallAdapterFactory.create());
            }
        });

        //////////////////////////////
        ////////// 文件请求客户端
        //////////////////////////////

        // 设置 FileClient 配置信息,用于发起文件/图片上传和下载请求,主要是非接口请求.
        config.setFileClientConfig(new NetworkConfig() {

            /**
             * 获取网络底层客户端构造器.
             *
             * @return 网络底层客户端构造器.
             */
            @Override
            public OkHttpClient.Builder getOkBuilder() {
                // 添加网络拦截器,用于打印网络请求日志
                return new OkHttpClient.Builder().addInterceptor(new HttpLoggingInterceptor());
            }

            /**
             * 获取网络 API 层客户端构造器.
             *
             * @return 网络 API 层客户端构造器.
             */
            @Override
            public Retrofit.Builder getReBuilder() {
                return new Retrofit.Builder()
                        // 添加 BaseUrl
                        /**
                         * 此处切换商联接口环境
                         */
                        .baseUrl(FileUtils.getBaseURL(envir))
                        // Gson 转换器
                        .addConverterFactory(GsonConverterFactory.create())
                        // RxJava2 转换器
                        .addCallAdapterFactory(RxJava2CallAdapterFactory.create());
            }
        });
        return config;
    }
}
