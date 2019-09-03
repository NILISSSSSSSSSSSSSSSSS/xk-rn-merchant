package com.xkshop.util;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import androidx.fragment.app.FragmentActivity;
import androidx.core.content.FileProvider;

import com.alibaba.android.arouter.launcher.ARouter;
import com.orhanobut.logger.Logger;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import cn.scshuimukeji.comm.ui.camera.JCameraView;
import cn.scshuimukeji.comm.ui.camera.util.FileUtil;
import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.im.R;
import cn.scshuimukeji.im.core.utils.IMBitmapUtil;

/**
 * @author FanCoder.LCY
 * @date 2018/9/4 10:45
 * @email 15708478830@163.com
 * @desc 拍照相关
 **/
public class CaptureManager {
    public static final int REQUEST_CODE_CAPTURE_NEED_CROP = 0x005;
    public static final int REQUEST_CODE_CAPTURE = 0x006;
    public static final int REQUEST_CODE_CAPTURE_CROP = 0x007;
    public static final int REQUEST_CODE_CAPTURE_VIDEO = 0x008;
    public static final int REQUEST_CODE_PHOTO_VIDEO = 0x009;
    public static String AUTHORITY = "cn.scshuimukeji.immerchanttest.fileprovider";
    private volatile static CaptureManager instance;
    // 拍照后保存的照片
    private File mImageFile;
    // 拍照后保存的照片的Uri
    private Uri mImageUri;
    // 拍摄后保存的视频
    private File mVideoFile;
    // 拍摄后保存的视频的Uri
    private Uri mVideoUri;
    // 视频缩略图
    private File mVideoFileThumbnail;

    private CaptureManager() {
    }

    public static CaptureManager getInstance() {
        if (instance == null) {
            synchronized (CaptureManager.class) {
                if (instance == null) {
                    instance = new CaptureManager();
                }
            }
        }
        return instance;
    }

    private File mImageClip;

    public File createClipImageFile() {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format
                (new Date());
        String fileName = "CLIP_IMG_" + timeStamp + ".jpg";
        mImageClip = new File(FileUtil.getSdGalleryPath() + File.separator + fileName);
        return mImageClip;
    }

    public File getImageClip() {
        return mImageClip;
    }

    /**
     * 拍照和录制
     *
     * @param activity
     */
    public void doCapture(FragmentActivity activity) {
        doCapture(activity, JCameraView.BUTTON_STATE_BOTH, false, 0);
    }

    /**
     * 拍照和录制（可单控制）
     *
     * @param activity
     * @param buttonMode 设置中间按钮模式 JCameraView.BUTTON_STATE_ONLY_CAPTURE 拍照;
     *                   JCameraView.BUTTON_STATE_ONLY_RECORDER 录制;
     *                   JCameraView.BUTTON_STATE_BOTH 都可
     * @param needCrop   是否需要裁剪
     */
    public void doCapture(FragmentActivity activity, int buttonMode, boolean needCrop, long duration) {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format
                (new Date());
        String photoFileName = "IMG_" + timeStamp + ".jpg";
        String photoPath = FileUtil.getSdGalleryPath() + File.separator + photoFileName;
        String videoFileName = "VIDEO_" + timeStamp + ".mp4";
        String videoPath = FileUtil.getSdGalleryPath() + File.separator + videoFileName;
        doCapture(activity, photoPath, videoPath, buttonMode, needCrop, duration);
    }

    /**
     * 跳转到拍照或录制页面
     *
     * @param activity   当前activity
     * @param photoPath  设置拍照后的照片路径
     * @param videoPath  设置录制后的小视频路径
     * @param buttonMode 设置中间按钮模式 JCameraView.BUTTON_STATE_ONLY_CAPTURE 拍照;
     *                   JCameraView.BUTTON_STATE_ONLY_RECORDER 录制;
     *                   JCameraView.BUTTON_STATE_BOTH 都可
     * @param needCrop   是否需要裁剪
     */
    @SuppressLint("CheckResult")
    public void doCapture(FragmentActivity activity, String photoPath, String videoPath, int buttonMode, boolean needCrop, long duration) {
        LoggerUtil.warning("CaptureManager", "true");
        ARouter.getInstance().build("/comm/camera/capture")
                .withString("photo_path", photoPath)
                .withString("video_path", videoPath)
                .withInt("button_mode", buttonMode)
                .withLong("duration", duration)
                .withFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                .navigation(activity, needCrop ? CaptureManager.REQUEST_CODE_CAPTURE_NEED_CROP : CaptureManager.REQUEST_CODE_PHOTO_VIDEO);
    }

    public Intent getSystemLittleVideoCaptureIntent(Context context) {
        Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 0);
        /** 录制视频最大时长10s**/
        intent.putExtra(MediaStore.EXTRA_DURATION_LIMIT, 10);
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        mVideoFile = createVideoFile();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            mVideoUri = FileProvider.getUriForFile(context, AUTHORITY,
                    mVideoFile);
            intent.putExtra(MediaStore.EXTRA_OUTPUT, mVideoUri);
        } else {
            intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mVideoFile));
        }
        return intent;

    }

    /**
     * 设置拍照intent
     */
    public Intent getSystemCaptureIntent(Context context) {
        mImageFile = createImageFile();
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            // 如果是7.0以上，使用FileProvider，否则会报错
            intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            mImageUri = FileProvider.getUriForFile(context, AUTHORITY, mImageFile);
            intent.putExtra(MediaStore.EXTRA_OUTPUT, mImageUri);// 设置拍照后图片保存的位置
        } else {
            intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mImageFile));// 设置拍照后图片保存的位置
        }
        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
        //设置图片保存的格式
        return intent;
    }

    /**
     * 设置拍照后调用裁剪intent
     */
    public Intent getSystemCaptureCropIntent() {
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.putExtra("crop", "true");
        if (android.os.Build.MANUFACTURER.contains("HUAWEI")) {// 华为特殊处理 不然会显示圆
            intent.putExtra("aspectX", 9998);
            intent.putExtra("aspectY", 9999);
        } else {
            intent.putExtra("aspectX", 1);   //X方向上的比例
            intent.putExtra("aspectY", 1);   //Y方向上的比例
        }
        intent.putExtra("outputX", 500); //裁剪区的宽
        intent.putExtra("outputY", 500);//裁剪区的高
        intent.putExtra("scale ", true); //是否保留比例
        intent.putExtra("return-data", false);//是否在Intent中返回图片
        intent.putExtra("noFaceDetaction", true);
        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString()); //设置输出图片的格式

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION); //添加这一句表示对目标应用临时授权该Uri所代表的文件
            intent.setDataAndType(mImageUri, "image/*");  //设置数据源,必须是由FileProvider创建的ContentUri
            intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mImageFile)); //设置输出
            // 不需要ContentUri,否则失败
            Logger.d("输入" + mImageUri);
            Logger.d("输出" + Uri.fromFile(mImageFile));
        } else {
            intent.setDataAndType(Uri.fromFile(mImageFile), "image/*");
            intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mImageFile));
        }
        return intent;
    }

    /**
     * 调用系统裁剪
     */
    public Intent getSystemCropIntent(Context context, String path) {
        mImageFile = createImageFile();
        mImageUri = FileProvider.getUriForFile(context, AUTHORITY, new File(path));

        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.putExtra("crop", "true");
        intent.putExtra("aspectX", 1);   //X方向上的比例
        intent.putExtra("aspectY", 1);   //Y方向上的比例
        intent.putExtra("outputX", 500); //裁剪区的宽
        intent.putExtra("outputY", 500);//裁剪区的高
        intent.putExtra("scale ", true); //是否保留比例
        intent.putExtra("return-data", false);//是否在Intent中返回图片
        intent.putExtra("noFaceDetaction", true);
        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString()); //设置输出图片的格式

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION); //添加这一句表示对目标应用临时授权该Uri所代表的文件
            intent.setDataAndType(mImageUri, "image/*");  //设置数据源,必须是由FileProvider创建的ContentUri
            // 不需要ContentUri,否则失败
            Logger.d("输入" + mImageUri);
            Logger.d("输出" + Uri.fromFile(mImageFile));
        } else {
            intent.setDataAndType(Uri.fromFile(mImageFile), "image/*");
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mImageFile)); //设置输出
        return intent;
    }

    private File createImageFile() {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format
                (new Date());
        String fileName = "IMG_" + timeStamp + ".jpg";
        return new File(FileUtil.getSdGalleryPath() + File.separator + fileName);
    }

    private File createVideoFile() {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format
                (new Date());
        String fileName = "VIDEO_" + timeStamp + ".mp4";
        return new File(FileUtil.getSdGalleryPath() + File.separator + fileName);
    }

    private File createVideoThumbFile() {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format
                (new Date());
        String fileName = "VIDEO_" + timeStamp + "_thumb.jpg";
        return new File(FileUtil.getSdGalleryPath() + File.separator + fileName);
    }


    /**
     * 转换 content:// uri
     */
    private Uri getImageContentUri(Context context, File imageFile) {
        String filePath = imageFile.getAbsolutePath();
        Cursor cursor = context.getContentResolver().query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                new String[]{MediaStore.Images.Media._ID},
                MediaStore.Images.Media.DATA + "=? ",
                new String[]{filePath}, null);

        if (cursor != null && cursor.moveToFirst()) {
            int id = cursor.getInt(cursor
                    .getColumnIndex(MediaStore.MediaColumns._ID));
            Uri baseUri = Uri.parse("content://media/external/images/media");
            cursor.close();
            return Uri.withAppendedPath(baseUri, "" + id);
        } else {
            if (imageFile.exists()) {
                ContentValues values = new ContentValues();
                values.put(MediaStore.Images.Media.DATA, filePath);
                return context.getContentResolver().insert(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
            } else {
                return null;
            }
        }
    }

    public File getImageFile() {
        return mImageFile;
    }

    public File getVideoFile() {
        return mVideoFile;
    }

    public String getVideoFileThumbnailPath(Context context) {
        if (null != mVideoFile && mVideoFile.exists() && mVideoFile.length() > 0) {
            Bitmap bitmapSrc = ThumbnailUtils.createVideoThumbnail(mVideoFile.getAbsolutePath(),
                    MediaStore.Images.Thumbnails.MICRO_KIND);
            mVideoFileThumbnail = createVideoThumbFile();
            Bitmap bitmapLogo = BitmapFactory.decodeResource(context.getResources(), R.drawable
                    .plaza_video_gray);
            return bitmap2File(IMBitmapUtil.addLogo(bitmapSrc, bitmapLogo), mVideoFileThumbnail);
        }
        return "";
    }

    public static String bitmap2File(Bitmap bitmap, File f) {
        if (f.exists()) f.delete();
        FileOutputStream fOut = null;
        try {
            fOut = new FileOutputStream(f);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
            fOut.flush();
            fOut.close();
        } catch (IOException e) {
            return null;
        }
        return f.getAbsolutePath();
    }
}
