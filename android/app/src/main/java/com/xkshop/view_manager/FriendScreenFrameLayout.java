package com.xkshop.view_manager;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;

import com.xkshop.R;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/1/28 12:00
 * Desc:   重写RequestLayout的自定义ViewGroup
 */
public class FriendScreenFrameLayout extends FrameLayout {
    public FriendScreenFrameLayout(Context context) {
        super(context);
        initView(context);
    }

    public FriendScreenFrameLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        initView(context);
    }

    public FriendScreenFrameLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView(context);
    }

    private void initView(Context context) {
        View view = inflate(context, R.layout.friend_screen_layout, this);
    }

    private final Runnable measureAndLayout = () -> {
        measure(
                MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY),
                MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY));
        layout(getPaddingLeft() + getLeft(), getPaddingTop() + getTop(), getWidth() + getPaddingLeft() + getLeft(), getHeight() + getPaddingTop() + getTop());
    };

    @Override
    public void requestLayout() {
        super.requestLayout();
        post(measureAndLayout);
    }

}
