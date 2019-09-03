package com.xkshop;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import android.widget.Toast;

import com.tbruyelle.rxpermissions2.Permission;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.xkshop.util.XKSLObserver;


import io.reactivex.Observable;


/**
 * Desc: 权限申请工具类
 *
 * @author FanCoder.LCY
 * @date 2018/10/23 04:12
 * @email 15708478830@163.com
 **/
public class PermissionUtil {
    private volatile static PermissionUtil sInstance;

    private RxPermissions mRxPermissions;

    private PermissionUtil() {}

    public static PermissionUtil getInstance() {
        if (sInstance == null) {
            synchronized (PermissionUtil.class) {
                if (sInstance == null) {
                    sInstance = new PermissionUtil();
                }
            }
        }
        return sInstance;
    }

    /**
     * activity中请求权限
     * @param activity activity实例
     * @param permissions 权限数组
     * @return Observable<Permission>
     */
    public Observable<Permission> requestPermissions(FragmentActivity activity, String... permissions) {
        mRxPermissions = new RxPermissions(activity);
        return mRxPermissions.requestEach(permissions);
    }

    /**
     * fragment中请求权限
     * @param fragment fragment实例
     * @param permissions 权限数组
     * @return Observable<Permission>
     */
    public Observable<Permission> requestPermissions(Fragment fragment, String... permissions) {
        mRxPermissions = new RxPermissions(fragment);
        return mRxPermissions.requestEach(permissions);
    }

    /**
     * activity中请求权限
     * @param activity activity实例
     * @param permissionAdapter permission回调抽象类
     * @param permissions 权限数组
     * @return Observable<Permission>
     */
    public void requestPermissions(FragmentActivity activity, PermissionAdapter permissionAdapter, String... permissions) {
        mRxPermissions = new RxPermissions(activity);
        mRxPermissions.requestEach(permissions).subscribe(new XKSLObserver<Permission>() {
            @Override
            public void success(Permission response) {
                if (response.granted) {
                    // permission is granted
                    permissionAdapter.granted(response);
                } else if(response.shouldShowRequestPermissionRationale) {
                    // At least one denied permission without ask never again
                    permissionAdapter.denied(response);
                } else {
                    // At least one denied permission with ask never again
                    // Need to go to the settings.
                    permissionAdapter.deniedNeverAgain(response);
                }
            }

            @Override
            public void error(String message) {
                Toast.makeText(activity, message, Toast.LENGTH_SHORT).show();
            }
        });
    }

    /**
     * fragment中请求权限
     * @param fragment fragment实例
     * @param permissionAdapter permission回调抽象类
     * @param permissions 权限数组
     * @return Observable<Permission>
     */
    public void requestPermissions(Fragment fragment, PermissionAdapter permissionAdapter, String... permissions) {
        mRxPermissions = new RxPermissions(fragment);
        mRxPermissions.requestEach(permissions).subscribe(new XKSLObserver<Permission>() {
            @Override
            public void success(Permission response) {
                if (response.granted) {
                    // permission is granted
                    permissionAdapter.granted(response);
                } else if(response.shouldShowRequestPermissionRationale) {
                    // At least one denied permission without ask never again
                    permissionAdapter.denied(response);
                } else {
                    // At least one denied permission with ask never again
                    // Need to go to the settings.
                    permissionAdapter.deniedNeverAgain(response);
                }
            }

            @Override
            public void error(String message) {
                Toast.makeText(fragment.getActivity(), message, Toast.LENGTH_SHORT).show();
            }
        });
    }

    /**
     * 权限申请回调接口
     */
    public interface PermissionCallBack {
        /**
         * 已授权
         */
        void granted(Permission permission) ;

        /**
         * 已拒绝，不勾选不再询问
         */
        void denied(Permission permission) ;

        /**
         * 已拒绝，勾选不再询问
         */
        void deniedNeverAgain(Permission permission);
    }

    /**
     * 权限申请回调抽象类
     */
    public static abstract class PermissionAdapter implements PermissionCallBack {
        @Override
        public void deniedNeverAgain(Permission permission) {
        }
    }
}
