package com.xkshop.share;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.PixelFormat;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;

import com.bumptech.glide.request.FutureTarget;
import com.facebook.react.bridge.Promise;
import com.scshuimukeji.login.logincore.api.application.ShareCallBackListener;
import com.scshuimukeji.share.SMShare;
import com.scshuimukeji.share.beans.SerializableBitmap;
import com.scshuimukeji.share.beans.ShareBean;

import cn.scshuimukeji.comm.CommApplication;
import cn.scshuimukeji.comm.net.GlideApp;
import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.comm.util.ToastUtil;
import io.reactivex.Single;
import io.reactivex.SingleObserver;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

/**
 * @Project XKGC
 * @Describe
 * @Author 鲍立志
 * @Date 2018/10/31
 * @Time 14:29
 */
public class Share {
    /**
     * 分享
     *
     * @param activity
     * @param type     分享到哪个平台
     * @param url      网页链接
     * @param title    标题
     * @param info     分享备注
     * @param iconUrl  缩略图地址
     */
    public static void share(Activity activity, SMShare.TYPE type, String url, String title, String info, String iconUrl, Promise promise) {
        ShareBean shareBean = new ShareBean();
        shareBean.url = url;
        shareBean.title = title;
        shareBean.message = info;
        shareBean.image = iconUrl;
        if (TextUtils.isEmpty(iconUrl)) {
            shareXX(activity, type, shareBean, promise);
        } else {
            Single.just(iconUrl)
                    .map(s -> {
                        FutureTarget<Bitmap> futureTarget = GlideApp.with(CommApplication.getInstance())
                                .asBitmap() //必须
                                .skipMemoryCache(true)
                                .load(s)
                                .centerCrop()
                                .submit(200, 200);
                        Bitmap bitmap = futureTarget.get();
                        if (bitmap == null) {
                            Drawable drawable = CommApplication.getInstance().getPackageManager().getDefaultActivityIcon();
                            if (drawable == null) {
                                throw new RuntimeException("获取链接图片出错");
                            }
                            if (drawable instanceof BitmapDrawable) {
                                return ((BitmapDrawable) drawable).getBitmap();
                            }
                            try {
                                Bitmap.Config config = drawable.getOpacity() != PixelFormat.OPAQUE ? Bitmap.Config.ARGB_8888 : Bitmap.Config.RGB_565;
                                bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), config);
                                Canvas canvas = new Canvas(bitmap);
                                drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
                                //将 drawable 的内容绘制到 bitmap的canvas 上面去.
                                drawable.draw(canvas);
                                return bitmap;
                            } catch (Exception e) {
                                e.printStackTrace();
                                throw new RuntimeException("获取链接图片出错");
                            }
                        }
                        return bitmap;
                    })
                    .map(SerializableBitmap::new)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(new SingleObserver<SerializableBitmap>() {
                        @Override
                        public void onSubscribe(Disposable d) {

                        }

                        @Override
                        public void onSuccess(SerializableBitmap serializableBitmap) {
                            shareBean.serializableBitmap = serializableBitmap;
                            shareXX(activity, type, shareBean, promise);
                        }

                        @Override
                        public void onError(Throwable e) {
                            LoggerUtil.info("XKLMSHARE", e.getMessage());
                            ToastUtil.show(e.getMessage());
                        }
                    });
        }

    }

    private static void shareXX(Activity activity, SMShare.TYPE type, ShareBean shareBean, Promise promise) {
        SMShare.share(activity, type, shareBean, new ShareCallBackListener() {
            @Override
            public void success() {
//                        ToastUtil.show("分享成功");
                promise.resolve("success");
            }

            @Override
            public void fail(String msg) {
//                ToastUtil.show(msg);
                promise.reject("101", "failed");
            }
        });
    }


}
