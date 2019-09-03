package com.xkshop.net.upload;

import android.os.Handler;
import android.os.Looper;

import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.Observer;

import com.alibaba.android.arouter.launcher.ARouter;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.xkshop.MainApplication;
import com.xkshop.util.CaptureManager;

import java.util.List;

import cn.scshuimukeji.comm.ui.camera.JCameraView;
import cn.scshuimukeji.comm.ui.gallery.GalleryLiveData;
import cn.scshuimukeji.comm.ui.gallery.GallerySelectActivity;
import cn.scshuimukeji.comm.ui.gallery.Picture;
import cn.scshuimukeji.comm.ui.gallery.XKMedia;
import cn.scshuimukeji.im.core.utils.clipimage.ClipImageActivity;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019-06-03 10:55
 * Desc:   获取照片或视频文件路径
 */
public class GetMediaManager {

    private static volatile GetMediaManager mInstance;

    private Promise mPromise;

    /**
     * promise是否已被调用
     */
    private boolean isPromiseCalled;

    private static FragmentActivity mActivity;

    /**
     * 相册选择回调监听
     */
    private Observer<List<Picture>> observer;

    /**
     * 图片是否需要裁剪
     * 0 不裁剪 1 裁剪
     */
    private int needCrop;

    /**
     * type 选择类型 1:图片 2:视频
     */
    private int type;

    /**
     * 视频大小限制
     * 0 不限制大小 >0 限制大小（单位KB）
     */
    private int limit;

    public boolean getNeedCrop() {
        return needCrop == 1;
    }

    public int getType() {
        return type;
    }

    public int getLimit() {
        return limit;
    }

    public Promise getPromise() {
        return mPromise;
    }

    public boolean isPromiseCalled() {
        return isPromiseCalled;
    }

    public void setPromiseCalled(boolean promiseCalled) {
        isPromiseCalled = promiseCalled;
    }

    private GetMediaManager() {

    }

    public static GetMediaManager getInstance() {
        return mInstance;
    }

    public static GetMediaManager getInstance(FragmentActivity activity) {
        if (mInstance == null) {
            synchronized (GetMediaManager.class) {
                if (mInstance == null) {
                    mInstance = new GetMediaManager();
                }
            }
        }
        mActivity = activity;
        return mInstance;
    }

    /**
     * 选择图片和视频
     * type 选择类型 1:图片 2:视频 3:图片视频混合选择
     * crop 是否需要裁剪 0 不裁剪 1 裁剪
     * total 需要选择的文件数量
     * limit 限制上传的文件大小 0 不限制大小 >0 限制大小（单位KB）
     * duration 限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
     */
    public void pickImageAndVideo(int type, int crop, int totalNum, int limit, int duration, Promise promise) {
        initObserver();
        this.mPromise = promise;
        setPromiseCalled(false);
        this.needCrop = crop;
        this.type = type;
        if (limit > 0) {
            this.limit = limit;
        }

        ARouter.getInstance()
                .build("/comm/gallery")
                .withInt(GallerySelectActivity.KEY_MAX_NUM, totalNum)
                .withInt(GallerySelectActivity.KEY_TYPE, type)
                .withString(GallerySelectActivity.KEY_SUB_NAME, "完成")
                .withInt(GallerySelectActivity.KEY_MAX_VIDEO_NUM, type == 3 ? 1 : totalNum)
                .withLong(GallerySelectActivity.MAX_VIDEO_LENGTH, duration * 1000)
                .navigation();

    }


    /**
     * 拍照或拍视频
     * type 选择类型 0:拍照，1:拍视频，2:既能拍照又能拍视频
     * crop 是否需要裁剪 0:不裁剪 1:裁剪 (仅当type为0时参数生效)
     * duration 限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
     */
    public void takeImageAndVideo(int type, int crop, int duration, Promise promise) {
        this.mPromise = promise;
        /**
         * 裁剪参数已传入CaptureManager,GetMediaManager的裁剪参数设为不裁剪
         */
        this.needCrop = 0;
        int mode = JCameraView.BUTTON_STATE_ONLY_CAPTURE;
        if (type == 1) {
            mode = JCameraView.BUTTON_STATE_ONLY_RECORDER;
        } else if (type == 2) {
            mode = JCameraView.BUTTON_STATE_BOTH;
        }
        CaptureManager.getInstance().doCapture(mActivity, mode, type == 0 && crop == 1, duration * 1000);
    }

    /**
     * 每次从RN选择相册图片，都要创建Observer，返回的时候remove observer
     */
    public void initObserver() {
        if (observer != null) {
            observer = null;
        }

        FragmentActivity activity = MainApplication.getInstance().getFragmentActivity();
        observer = pictures -> {
            if (GetMediaManager.getInstance() != null && pictures != null && pictures.size() > 0) {
                if (isPromiseCalled()) {
                    return;
                }
                if (GetMediaManager.getInstance().getNeedCrop()) {
                    //获取到选择后的图片地址进行裁剪
                    ClipImageActivity.prepare()
                            .aspectX(1).aspectY(1)
                            .inputPath(pictures.get(0).path)
                            .outputPath(CaptureManager.getInstance().createClipImageFile().getAbsolutePath())
                            .startForResult(activity, CaptureManager.REQUEST_CODE_CAPTURE_CROP);
                } else {
                    WritableArray writableArray = Arguments.createArray();
                    for (Picture picture : pictures) {
                        WritableMap writableMap = Arguments.createMap();
                        //如果是视频
                        if (picture instanceof XKMedia) {
                            if (GetMediaManager.getInstance().getLimit() > 0 && GetMediaManager.getInstance().getLimit() < ((XKMedia) picture).size / 1024) {
                                GetMediaManager.getInstance().getPromise().reject("1088", "视频超过最大" + GetMediaManager.getInstance().getLimit() / 1024 + "M限制");
                                return;
                            }
                            writableMap.putString("imagePath", ((XKMedia) picture).videoThumbnailPath);
                            writableMap.putString("videoPath", picture.path);
                        } else {
                            writableMap.putString("imagePath", picture.path);
                        }
                        writableArray.pushMap(writableMap);
                    }
                    GetMediaManager.getInstance().getPromise().resolve(writableArray);
                    GetMediaManager.getInstance().setPromiseCalled(true);
                }
            }
            removeObserver();
        };

        new Handler(Looper.getMainLooper()).post(() -> GalleryLiveData.getInstance().getSelectListLiveData().observe(activity, observer));
    }

    public void removeObserver() {
        if (observer != null && GalleryLiveData.getInstance().getSelectListLiveData().hasObservers()) {
            GalleryLiveData.getInstance().getSelectListLiveData().removeObserver(observer);
            observer = null;
        }
        if (observer != null) {
            observer = null;
        }
    }

}
