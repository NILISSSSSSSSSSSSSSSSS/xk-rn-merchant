package com.xkshop.net.upload;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.util.Log;

import com.alibaba.android.arouter.launcher.ARouter;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ObjectAlreadyConsumedException;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.qiniu.android.common.AutoZone;
import com.qiniu.android.storage.Configuration;
import com.qiniu.android.storage.UploadManager;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

import cn.scshuimukeji.comm.CommApplication;
import cn.scshuimukeji.comm.animation.DefValue;
import cn.scshuimukeji.comm.ui.gallery.GallerySelectActivity;
import cn.scshuimukeji.comm.ui.gallery.Picture;
import cn.scshuimukeji.comm.ui.gallery.XKMedia;
import cn.scshuimukeji.comm.util.ToastUtil;
import cn.scshuimukeji.im.core.widget.dialog.CustomProgressDialogManager;
import io.reactivex.Observable;

/**
 * @Describe 图片视频上传
 * @Author 鲍立志
 * @Date 2018/9/6
 */
public class MultipleUploadManager {
    private static final String TAG = "MultipleUploadManager";
    private static volatile MultipleUploadManager mInstance;
    private String qiniuToken;
    public Promise promise;
    private int uploadNum;
    private int successNum;
    private static int overSize;
    private static Activity mActivity;

    private MultipleUploadManager() {
    }


    public static MultipleUploadManager getInstance() {
        return mInstance;
    }

    public static MultipleUploadManager getInstance(String qiniuToken, Promise promise, Activity activity) {
        if (mInstance == null) {
            synchronized (MultipleUploadManager.class) {
                if (mInstance == null) {
                    mInstance = new MultipleUploadManager();
                }
            }
        }
        mActivity = activity;
        mInstance.qiniuToken = qiniuToken;
        mInstance.promise = promise;
        mInstance.uploadNum = 0;
        mInstance.successNum = 0;
        return mInstance;
    }

    public void onPickResult(List<Picture> pictures) {
        if (pictures.isEmpty()) {
            promise.resolve(null);
            return;
        }
        boolean isUploadVideo = false;
        for (Picture item : pictures) {
            if (item instanceof XKMedia && ((XKMedia) item).mediaType == DefValue.MEDIA_TYPE_VIDEO) {
                isUploadVideo = true;
            }
        }
        if (isUploadVideo) {
            onVideoPickResult(Observable.create(emitter -> {
                List<String> paths = new ArrayList<>();
                for (Picture picture : pictures) {
                    XKMedia xkMedia = (XKMedia) picture;
                    if (xkMedia.mediaType == DefValue.MEDIA_TYPE_VIDEO) {
                        paths.add(xkMedia.path);
                    }
                }
                if (paths.size() > 0) {
                    emitter.onNext(paths);
                }
            })).subscribe();
        } else {
            onPhotoPickResult(Observable.create(emitter -> {
                List<String> paths = new ArrayList<>();
                for (Picture picture : pictures) {
                    XKMedia xkMedia = (XKMedia) picture;
                    if (xkMedia.mediaType == DefValue.MEDIA_TYPE_IMAGE) {
                        paths.add(xkMedia.path);
                    }
                }
                if (paths.size() > 0) {
                    emitter.onNext(paths);
                }
            })).subscribe();
        }
    }


    public void upLoadImage(int maxImageNum, Context context) {
        ARouter.getInstance()
                .build("/rn/gallery")
                .withInt(GallerySelectActivity.KEY_MAX_NUM, maxImageNum)
                .withInt(GallerySelectActivity.KEY_TYPE, GallerySelectActivity.TYPE_ONLY_IMAGE)
                .navigation();
    }

    public Observable<List<String>> onPhotoPickResult(Observable<List<String>> photoPickObservable) {
        return photoPickObservable.doOnNext(paths -> {
            if (paths.isEmpty()) return;
            CustomProgressDialogManager.getInstance().showLoading(mActivity, "上传图片中");
            String key = null;
            String token = qiniuToken;
            Configuration config = new Configuration.Builder()
                    .chunkSize(512 * 1024)        // 分片上传时，每片的大小。 默认256K
                    .putThreshhold(1024 * 1024)   // 启用分片上传阀值。默认512K
                    .connectTimeout(10)           // 链接超时。默认10秒
                    .responseTimeout(60)          // 服务器响应超时。默认60秒
                    .zone(AutoZone.autoZone)
                    .build();
            UploadManager uploadManager = new UploadManager(config);
            Bitmap[] images;
            try {
                images = compressImages(paths.toArray(new String[]{}));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                WritableArray writableArray = Arguments.createArray();
                WritableMap writableMap = Arguments.createMap();
                writableMap.putString("imageUrl", null);
                writableArray.pushMap(writableMap);
                if (promise != null) {
                    promise.resolve(writableArray);
                    promise = null;
                }
                return;
            }
            WritableArray result = Arguments.createArray();
            int imageCount = images.length;
            try {
                for (Bitmap image : images) {
                    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                    image.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
                    byte[] data = byteArrayOutputStream.toByteArray();
                    uploadManager.put(data, key, token,
                            (key1, info, res) -> {
                                WritableMap uploadPictuer = Arguments.createMap();
                                uploadNum++;
                                //请求完成
                                if (info.isOK()) {
                                    successNum++;
                                    uploadPictuer.putString("imageUrl", res.optString("key"));
                                    result.pushMap(uploadPictuer);
                                    Log.i("qiniu", "Upload Success" + "   " + res.optString("key"));
                                } else {
                                    uploadPictuer.putNull("imageUrl");
                                    result.pushMap(uploadPictuer);
                                    Log.i("qiniu", "Upload Fail" + info.toString());
                                }

                                if (uploadNum == imageCount) {
                                    if (successNum == imageCount) {
                                        CustomProgressDialogManager.getInstance().showSuccess(mActivity, "上传成功");
                                        if (promise != null) {
                                            promise.resolve(result);
                                            promise = null;
                                        }
                                    } else {
                                        mActivity.runOnUiThread(() -> CustomProgressDialogManager.getInstance().showFail(mActivity, "上传失败"));
                                        if (promise != null) {
                                            promise.reject("1086", "图片上传失败");
                                            promise = null;
                                        }
                                    }
                                }
                            }, null);
                }
            } catch (ObjectAlreadyConsumedException e) {
                ToastUtil.show("选择出错，请重新进入相册选择");
                if (promise != null) {
                    promise.reject("1086", e.getMessage());
                    promise = null;
                }
            }
        });

    }

    public void uploadVideo(int size) {
        //权限已经被授予,打开相册
        if (size > 0) {
            overSize = size;
        }
        ARouter.getInstance()
                .build("/rn/gallery")
                .withInt(GallerySelectActivity.KEY_MAX_NUM, 1)
                .withInt(GallerySelectActivity.KEY_TYPE, GallerySelectActivity.TYPE_ONLY_VIDEO)
                .navigation();
    }

    public Observable<List<String>> onVideoPickResult(Observable<List<String>> videoPickObservable) {
        return videoPickObservable.doOnNext(paths -> {
            if (paths.isEmpty()) return;
            if (overSize > 0 && UploadUtils.isOverSize(paths.get(0), overSize)) {
                String message = "上传视频大小需在" + overSize / 1024 + "M以内";
                ToastUtil.show(message);
                if (promise != null) {
                    promise.reject("1085", message);
                    promise = null;
                }
                return;
            }
            CustomProgressDialogManager.getInstance().showLoading(mActivity, "上传视频中");
            String key = null;
            String token = qiniuToken;
            Configuration config = new Configuration.Builder()
                    .chunkSize(512 * 1024)        // 分片上传时，每片的大小。 默认256K
                    .putThreshhold(1024 * 1024)   // 启用分片上传阀值。默认512K
                    .connectTimeout(10)           // 链接超时。默认10秒
                    .responseTimeout(60)          // 服务器响应超时。默认60秒
                    .zone(AutoZone.autoZone)
                    .build();
            UploadManager uploadManager = new UploadManager(config);
            uploadManager.put(paths.get(0), key, token,
                    (key1, info, res) -> {
                        WritableArray writableArray = Arguments.createArray();
                        WritableMap writableMap = Arguments.createMap();
                        //请求完成
                        if (info.isOK()) {
                            writableMap.putString("videoUrl", res.optString("key"));
                            Log.i("qiniu", "Upload Success" + res.optString("key"));
                            writableArray.pushMap(writableMap);
                            if (promise != null) {
                                promise.resolve(writableArray);
                                promise = null;
                            }
                            CustomProgressDialogManager.getInstance().showSuccess(mActivity, "上传成功");
                        } else {
                            writableMap.putString("videoUrl", null);
                            Log.i("qiniu", "Upload Fail" + info.toString());
                            if (promise != null) {
                                promise.reject("1086", "视频上传失败");
                                promise = null;
                            }
                            mActivity.runOnUiThread(() -> CustomProgressDialogManager.getInstance().showFail(mActivity, "上传失败"));
                        }
                    }, null);
        });
    }

    private Bitmap compressPixel(String path) throws FileNotFoundException {
        Bitmap bmp = null;
        BitmapFactory.Options options = new BitmapFactory.Options();
        //setting inSampleSize value allows to load a scaled down version of the original image
        options.inSampleSize = 2;

        //inJustDecodeBounds set to false to load the actual bitmap
        options.inJustDecodeBounds = false;
        options.inTempStorage = new byte[16 * 1024];
        FileInputStream fileInputStream = new FileInputStream(path);
        bmp = BitmapFactory.decodeStream(fileInputStream, null, options);
        return bmp;
    }

    public Bitmap[] compressImages(String[] paths) throws FileNotFoundException {
        Bitmap[] images = new Bitmap[paths.length];
        for (int i = 0; i < images.length; i++) {
            images[i] = compressPixel(paths[i]);
        }
        return images;
    }

    private String[] parsePaths(Uri uri, String column) {
        String[] paths = null;
        String[] filePathColumn = {column};
        Cursor cursor = CommApplication.getInstance().getContentResolver().query(uri, null, null, null, null);
        if (cursor == null) {
            promise.resolve("没有选择");
            return null;
        }
        int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
        paths = new String[cursor.getCount()];
        cursor.moveToFirst();
        int index = 0;
        while (!cursor.isAfterLast()) {
            paths[index] = cursor.getString(columnIndex);
            cursor.moveToNext();
            Log.e(TAG, "onPhotoPickResult: " + paths[index]);
            index++;
        }
        cursor.close();
        return paths;
    }


}
