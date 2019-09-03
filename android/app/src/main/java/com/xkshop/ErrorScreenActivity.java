package com.xkshop;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.xkshop.util.FileUtils;

import cn.scshuimukeji.comm.util.LoggerUtil;
import cn.scshuimukeji.comm.util.ResourceUtil;
import cn.scshuimukeji.comm.util.StatusUtil;
import cn.scshuimukeji.im.core.utils.CommonViewUtils;

/**
 * Author:柏洲
 * Email: baizhoussr@gmail.com
 * Date:  2019/5/7 16:22
 * Desc:
 */
public class ErrorScreenActivity extends Activity {

    private static final String TAG = "ErrorScreenActivity";

    private String stackTraceString;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        stackTraceString = "StackTrace unavailable";
        try {
            stackTraceString = getIntent().getExtras().getString("stack_trace_string");
        } catch (Exception e) {
            LoggerUtil.warning(TAG, String.format("Was not able to get StackTrace: %s", e.getMessage()));
        }
        LoggerUtil.warning(TAG, stackTraceString);
        setContentView(R.layout.activity_error_screen);
        StatusUtil.setSystemStatus(this, false, true);
        initView();

        initErrorShow();
    }

    private void initErrorShow() {
        String envir = FileUtils.getRequestConfig(this, "requestConfig.json").envir;
        if (!"3".equals(envir)) {
            EditText errorShowTv = findViewById(R.id.error_show_tv);
            errorShowTv.setMovementMethod(ScrollingMovementMethod.getInstance());
            errorShowTv.setText(stackTraceString);
            ConstraintLayout container = findViewById(R.id.error_container);
            container.setOnLongClickListener(v -> {
                errorShowTv.setVisibility(errorShowTv.getVisibility() == View.VISIBLE ? View.GONE : View.VISIBLE);
                return true;
            });
        }
    }

    private void initView() {
        TextView restartTv = findViewById(R.id.restart_btn);
        TextView exitTv = findViewById(R.id.exit_btn);
        restartTv.setBackground(CommonViewUtils.generateRectAngleDrawable(ResourceUtil.getColor(R.color.color_4A90FA), 8));
        exitTv.setBackground(CommonViewUtils.generateRectAngleDrawable(ResourceUtil.getColor(R.color.color_4A90FA), 8));
        restartTv.setOnClickListener(v -> {
            doRestart(getApplicationContext());
        });
        exitTv.setOnClickListener(v -> {
            System.exit(0);
        });
    }

    public static void doRestart(Context c) {
        try {
            if (c != null) {
                PackageManager pm = c.getPackageManager();
                if (pm != null) {
                    Intent mStartActivity = pm.getLaunchIntentForPackage(
                            c.getPackageName()
                    );
                    if (mStartActivity != null) {
                        mStartActivity.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                        int mPendingIntentId = 654311;
                        PendingIntent mPendingIntent = PendingIntent
                                .getActivity(c, mPendingIntentId, mStartActivity,
                                        PendingIntent.FLAG_CANCEL_CURRENT);
                        AlarmManager mgr = (AlarmManager) c.getSystemService(Context.ALARM_SERVICE);
                        mgr.set(AlarmManager.RTC, System.currentTimeMillis() + 100, mPendingIntent);
                        System.exit(0);
                    } else {
                        throw new Exception("Was not able to restart application, mStartActivity null");
                    }
                } else {
                    throw new Exception("Was not able to restart application, PM null");
                }
            } else {
                throw new Exception("Was not able to restart application, Context null");
            }
        } catch (Exception ex) {
            Log.e(TAG, "Was not able to restart application");
        }
    }
}
