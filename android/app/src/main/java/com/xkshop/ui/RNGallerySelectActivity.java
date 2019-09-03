package com.xkshop.ui;


import androidx.appcompat.widget.Toolbar;
import android.view.View;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.xkshop.R;
import com.xkshop.net.upload.MultipleUploadManager;
import com.xkshop.promise.BackPressedPromise;

import cn.scshuimukeji.comm.ui.gallery.GallerySelectActivity;

@Route(path = "/rn/gallery")
public class RNGallerySelectActivity extends GallerySelectActivity {
    @Override
    public void onViewCreate(View view) {
        super.onViewCreate(view);
        Toolbar toolbar = findViewById(cn.scshuimukeji.comm.R.id.tool_bar);
        toolbar.setTitle("");
        toolbar.setNavigationIcon(cn.scshuimukeji.comm.R.drawable.comm_ic_back);
        setSupportActionBar(toolbar);
        toolbar.setNavigationOnClickListener(v -> {
            MultipleUploadManager.getInstance().promise.resolve(false);
            finish();
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (R.id.text_view_cancel == v.getId()) {
            MultipleUploadManager.getInstance().promise.resolve(false);
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        BackPressedPromise.getInstance().resolve(null);
    }
}
