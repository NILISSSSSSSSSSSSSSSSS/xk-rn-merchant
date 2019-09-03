package com.xkshop.scan;

import android.text.TextUtils;
import android.util.ArrayMap;

import java.io.Serializable;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;

/**
 * @ProjectName: XKGC
 * @Description: 晓可URL 特殊类
 * @Author: 王景
 * @CreateDate: 2018/11/14 18:33
 * @Version: 1.0
 */
public class SMURL implements Serializable {

    private String protocol;
    private String host;
    private String query;
    private String smurl;
    public SMURL(String smurl) {
        this.smurl = new String(smurl);
        try {
            URL url = new URL(smurl);
            protocol = url.getProtocol();
            host = url.getHost();
            query = url.getQuery();
            if(TextUtils.isEmpty(query)){
                query = "";
                if(smurl.indexOf("?") != -1){
                    query = smurl.substring(smurl.indexOf("?")+1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            protocol = smurl.split("://")[0];
            try {
                URL url = new URL(smurl.replaceFirst(protocol,"http"));
                host = url.getHost();
                query = url.getQuery();
                query = url.getQuery();
                if(TextUtils.isEmpty(query)){
                    query = "";
                    if(smurl.indexOf("?") != -1){
                        query = smurl.substring(smurl.indexOf("?")+1);
                    }
                }
            } catch (MalformedURLException e1) {
                e1.printStackTrace();
            }
        }
    }

    public String getProtocol() {
        return protocol;
    }

    public String getHost() {
        return host;
    }

    public String getQuery() {
        return query;
    }

    public Map<String,String> getParams(){
        Map<String,String> map = new ArrayMap<String, String>();
        String[] arrSplit=null;
        arrSplit=query.split("&");
        for(String strSplit:arrSplit)
        {
            String[] arrSplitEqual=null;
            arrSplitEqual= strSplit.split("=");
            //解析出键值
            if(arrSplitEqual.length>1)
            {
                //正确解析
                map.put(arrSplitEqual[0], arrSplitEqual[1]);
            }
            else
            {
                if(!TextUtils.isEmpty(arrSplitEqual[0]))
                {
                    //只有参数没有值，不加入
                    map.put(arrSplitEqual[0], "");
                }
            }
        }
        return map;
    }
}
