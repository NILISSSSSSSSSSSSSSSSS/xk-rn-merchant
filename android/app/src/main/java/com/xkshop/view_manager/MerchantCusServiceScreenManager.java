package com.xkshop.view_manager;

import androidx.constraintlayout.widget.ConstraintLayout;
import android.view.LayoutInflater;
import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.xkshop.MainApplication;
import com.xkshop.R;

import cn.scshuimukeji.im.customer_service.ServiceChatManager;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/1/19 14:41
 * Desc:
 */
public class MerchantCusServiceScreenManager extends SimpleViewManager<ConstraintLayout> implements View.OnClickListener {

    public static final String REACT_CLASS = "MerchantCusServiceFrameLayout";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    private ServiceChatManager manager;

    public static String teamIcon = "http://gc.xksquare.com/%E5%AE%A2%E6%9C%8D%E5%A4%B4%E5%83%8F@2x.png";

    @Override
    protected ConstraintLayout createViewInstance(ThemedReactContext reactContext) {
        ConstraintLayout root = (ConstraintLayout) LayoutInflater.from(reactContext)
            .inflate(R.layout.im_fragment_merchant_platform_service, null);

        manager = new ServiceChatManager(MainApplication.getInstance().getFragmentActivity());

        root.findViewById(R.id.shop_tv).setOnClickListener(this);

        root.findViewById(R.id.live_tv).setOnClickListener(this);

        root.findViewById(R.id.partner_tv).setOnClickListener(this);

        root.findViewById(R.id.personal_tv).setOnClickListener(this);

        root.findViewById(R.id.family_tv).setOnClickListener(this);

        root.findViewById(R.id.union_tv).setOnClickListener(this);

        return root;
//        return new MerchantCusServiceFrameLayout(reactContext);
    }

    @Override
    public void onClick(View v) {
        manager.contactXKService("商联客服", teamIcon);
    }
}
