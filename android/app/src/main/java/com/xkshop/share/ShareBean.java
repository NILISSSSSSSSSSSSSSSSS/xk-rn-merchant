package com.xkshop.share;

import java.io.Serializable;

/**
 * Author: 柏洲
 * Email:  baizhoussr@gmail.com
 * Date:   2019/3/14 14:16
 * Desc:   分享给可友的商品或是福利
 */
public class ShareBean implements Serializable {
    //商品Id
    public String goodsId;

    //期Id
    public String sequenceId;

    //图片地址
    public String iconUrl;

    //名称
    public String name;

    //价格
    public String price;

    //描述/规格
    public String description;

    //0 商品 1 福利
    public int type;
}
