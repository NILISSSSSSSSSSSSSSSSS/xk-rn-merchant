package com.xkshop.util;

import android.content.Context;
import android.content.res.AssetManager;

import com.google.gson.Gson;
import com.xkshop.im.RequestConfig;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/2/20 15:49
 * Desc:   文件工具类
 */
public class FileUtils {

    //开发
    private static final String DEV_H5_URL = "://dev.xksquare.com";
    private static final String DEV_BASE_URL = "://dev.api.xksquare.com/";

    //测试
    private static final String TEST_H5_URL = "://testw.xksquare.com";
    private static final String TEST_BASE_URL = "://testw.api.xksquare.com/";

    //预发布
    private static final String BETA_H5_URL = "://final.xksquare.com";
    private static final String BETA_BASE_URL = "://final.api.xksquare.com/";

    //线上
    private static final String RELEASE_H5_URL = "://xkadmin.xksquare.com";
    private static final String RELEASE_BASE_URL = "://pe.api.xksquare.com/";

    /**
     * 得到json文件中的内容
     */
    public static String getJson(Context context, String fileName) {
        StringBuilder stringBuilder = new StringBuilder();
        //获得assets资源管理器
        AssetManager assetManager = context.getAssets();
        //使用IO流读取json文件内容
        try {
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(
                    assetManager.open(fileName), "utf-8"));
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringBuilder.toString();
    }

    /**
     * 获取请求配置中的当前环境
     */
    public static RequestConfig getRequestConfig(Context context, String fileName) {
        String configStr = getJson(context, fileName);
        Gson gson = new Gson();
        RequestConfig config = gson.fromJson(configStr, RequestConfig.class);
        return config;
    }


    /**
     * 获取H5 url
     *
     * @param config :"0 正式 1 dev 2 test 3 预发布"
     */
    public static String getH5URL(RequestConfig config) {
        switch (config.envir) {
            case "0":
                return config.netHeader + RELEASE_H5_URL;
            case "1":
                return config.netHeader + DEV_H5_URL;
            case "3":
                return config.netHeader + BETA_H5_URL;
            case "2":
            default:
                return config.netHeader + TEST_H5_URL;
        }
    }

    /**
     * 获取Base url
     *
     * @param config :"0 正式 1 dev 2 test 3 预发布"
     */
    public static String getBaseURL(RequestConfig config) {
        switch (config.envir) {
            case "0":
                return config.netHeader + RELEASE_BASE_URL;
            case "1":
                return config.netHeader + DEV_BASE_URL;
            case "3":
                return config.netHeader + BETA_BASE_URL;
            case "2":
            default:
                return config.netHeader + TEST_BASE_URL;
        }
    }
}
