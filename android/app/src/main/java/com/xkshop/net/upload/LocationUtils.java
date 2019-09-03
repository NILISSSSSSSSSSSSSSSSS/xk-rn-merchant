package com.xkshop.net.upload;


import com.baidu.location.Address;
import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.BDLocation;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.xkshop.MainApplication;

/**
 * @Project XKGC
 * @Describe
 * @Author 鲍立志
 * @Date 2018/9/4
 * @Time 15:29
 */
public class LocationUtils {
    LocationClient locationClient;

    boolean firstRequest;


    public void requireLocation(Promise promise) {
        firstRequest = true;
        locationClient = new LocationClient(MainApplication.getInstance());
        LocationClientOption locationClientOption = new LocationClientOption();
        locationClientOption.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);
        locationClientOption.setIsNeedAddress(true);
//        locationClientOption.setScanSpan(1000);
//        locationClientOption.setOpenGps(true);
        locationClient.setLocOption(locationClientOption);
        locationClient.registerLocationListener(new BDAbstractLocationListener() {
            @Override
            public void onReceiveLocation(BDLocation bdLocation) {
                WritableMap writableMap = Arguments.createMap();
                Address address = bdLocation.getAddress();
                writableMap.putString("address", address.address);
                writableMap.putString("lat", String.valueOf(bdLocation.getLatitude()));
                writableMap.putString("province", address.province);
                writableMap.putString("lon", String.valueOf(bdLocation.getLongitude()));
                writableMap.putString("city", address.city);
                writableMap.putString("region", address.district);
                if (firstRequest) {
                    promise.resolve(writableMap);
                    firstRequest = false;
                }
            }
        });
        locationClient.start();
    }
}
