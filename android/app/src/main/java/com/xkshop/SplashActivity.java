package com.xkshop;

import android.Manifest;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.util.Log;
import android.view.View;

import com.tbruyelle.rxpermissions2.Permission;

public class SplashActivity extends AppCompatActivity {
    private static final String TAG = "SplashActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.launch_screen);
        View view = findViewById(R.id.root);
        PermissionUtil.getInstance().requestPermissions(this, new PermissionUtil
            .PermissionAdapter() {
            @Override
            public void granted(Permission permission) {
                Log.e(TAG, "granted: ");
                setResult(RESULT_OK);
                view.postDelayed(() -> finish(), 2000);
            }

            @Override
            public void denied(Permission permission) {
                Log.e(TAG, "denied: ");
                if (Manifest.permission.ACCESS_FINE_LOCATION.equals(permission.name)) {
                    setResult(RESULT_OK);
                }
                view.postDelayed(() -> finish(), 2000);
            }

            @Override
            public void deniedNeverAgain(Permission permission) {
                Log.e(TAG, "deniedNeverAgain: ");
                if (Manifest.permission.ACCESS_FINE_LOCATION.equals(permission.name)) {
                    setResult(RESULT_OK);
                }
                view.postDelayed(() -> finish(), 2000);
            }
        }, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION);
    }

    @Override
    protected void onResume() {
        super.onResume();
    }
}
