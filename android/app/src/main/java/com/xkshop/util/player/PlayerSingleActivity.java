package com.xkshop.util.player;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.pili.pldroid.player.PLOnCompletionListener;
import com.pili.pldroid.player.PLOnPreparedListener;
import com.pili.pldroid.player.PLOnSeekCompleteListener;
import com.pili.pldroid.player.widget.PLVideoView;
import com.xkshop.R;

import cn.scshuimukeji.comm.util.ResourceUtil;
import cn.scshuimukeji.comm.util.StatusUtil;
import cn.scshuimukeji.im.core.ImageLoader;

/**
 * Desc: 单视频纯播放Activity
 *
 * @author FanCoder.LCY
 * @date 2019-06-17 11:51
 * @email 15708478830@163.com
 * 注意: 本内容仅限于四川水木科技有限公司内部传阅，禁止外泄以及用于其他的商业目的
 **/
@Route(path = "/rn/player")
public class PlayerSingleActivity extends AppCompatActivity implements PLOnPreparedListener,
        PLOnSeekCompleteListener, PLOnCompletionListener {
    /**
     * 是否循环播放
     */
    private boolean isLoop;
    /**
     * 下次播放是否从头开始
     */
    private boolean isRestart = false;
    /**
     * 是否手动暂停了
     */
    private boolean isHandPause = false;

    private PLVideoView mPreview;
    private ImageView play;
    private boolean isFirst = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_merchant_player);
        StatusUtil.setUseStatusBarColor(this, ResourceUtil.getColor(R.color.transparency_color));
        StatusUtil.setSystemStatus(this, true, false);
        Intent intent = getIntent();
        // 视频地址
        String videoPath = intent.getStringExtra("videoPath");
        isLoop = intent.getBooleanExtra("isLoop", isLoop);

        mPreview = findViewById(R.id.single_video_view);
        play = findViewById(R.id.img_single_play);
        ImageView ivBack = findViewById(R.id.iv_back);

        ivBack.setOnClickListener(view -> finish());
        StatusUtil.addMarginTopEqualStatusBarHeight(ivBack);

        LinearLayout loadingView = findViewById(R.id.spin_kit);
//        loadingView.setBackgroundColor(Color.TRANSPARENT);
        mPreview.setBufferingIndicator(loadingView);
        ImageView coverView = findViewById(R.id.cover_view);
        ImageLoader.getInstance().load(coverView, videoPath + "?vframe/jpg/offset/0");
        mPreview.setCoverView(coverView);

        mPreview.setVideoPath(videoPath);
        initPreview();
        mPreview.setLooping(isLoop);

        play.setOnClickListener(view -> {
            if (mPreview != null && mPreview.isPlaying()) {
                isHandPause = true;
                pauseVideo();
            } else if (mPreview != null && !mPreview.isPlaying()) {
                isHandPause = false;
                play();
            }
        });
        play();
    }


    private void initPreview() {
        mPreview.setDisplayAspectRatio(PLVideoView.ASPECT_RATIO_PAVED_PARENT);
        mPreview.setOnPreparedListener(this);
        mPreview.setOnCompletionListener(this);
    }

    private void play() {
        isHandPause = false;
        if (mPreview != null && !isLoop && isRestart) {
            isFirst = false;
            mPreview.seekTo(0);
            mPreview.start();
            play.animate().alpha(0f).start();
            isRestart = false;
        } else if (mPreview != null) {
            isFirst = false;
            mPreview.start();
            play.animate().alpha(0f).start();
            isRestart = false;
        }
    }

    private void releaseVideo() {
        if (!isFirst) {
            if (mPreview != null) {
                mPreview.stopPlayback();
                play.animate().alpha(0f).start();
            }
        }
    }

    private void pauseVideo() {
        if (!isFirst) {
            if (mPreview != null) {
                mPreview.pause();
                play.animate().alpha(1f).start();
            }
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        pauseVideo();
    }

    @Override
    protected void onStop() {
        super.onStop();
        releaseVideo();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mPreview != null) {
            mPreview.stopPlayback();
            mPreview = null;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (!isFirst && !isHandPause && !isRestart) {
            play();
        }
    }

    @Override
    public void onCompletion() {
        if (!isLoop) {
            play.animate().alpha(1f).start();
            isRestart = true;
        }
    }

    @Override
    public void onPrepared(int i) {
    }

    @Override
    public void onSeekComplete() {
    }
}
