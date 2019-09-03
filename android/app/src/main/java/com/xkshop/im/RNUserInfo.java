package com.xkshop.im;

import java.io.Serializable;
import java.util.List;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/1/19 13:24
 * Desc:   RN登录成功后传递给原生的用户信息
 */
public class RNUserInfo implements Serializable {

    public int createdMerchant;
    public String nickName;
    public long securityCode;
    public String avatar;
    public String token;
    public UserImAccountBean userImAccount;
    public String realName;
    public String phone;
    public String merchantId;
    public String auditStatus;
    public String id;
    public String qrCode;
    public List<MerchantBean> merchant;

    public static class UserImAccountBean {
        /**
         * accid : 5c4abd41033455346a1c38f4
         * token : 4641657a4f663ecca06bccb43bf2b97a
         */

        public String accid;
        public String token;
    }

    public static class MerchantBean {
        /**
         * name : 主播
         * auditStatus : 0
         * agreement : ZB
         * merchantType : anchor
         */

        public String name;
        public int auditStatus;
        public String agreement;
        public String merchantType;
    }

}
