package com.xkshop.view_manager;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/2/18 18:55
 * Desc:
 */
public class CusFrameLayout extends FrameLayout {
    public CusFrameLayout(Context context) {
        super(context);
    }

    public CusFrameLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CusFrameLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    private final Runnable measureAndLayout = () -> {
        measure(
            MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY),
            MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY));
        layout(getLeft(), getTop(), getRight(), getBottom());
    };

    @Override
    public void requestLayout() {
        super.requestLayout();
        post(measureAndLayout);
    }
}
