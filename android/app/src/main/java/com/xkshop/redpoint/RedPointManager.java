package com.xkshop.redpoint;

/**
 * Author:柏洲
 * Email: baizhoussr@gmail.com
 * Date:  2019/4/17 15:21
 * Desc:
 */
public class RedPointManager {

    private static volatile RedPointManager instance;

    private RedPointManager() {
    }

    public static RedPointManager getInstance() {
        if (instance == null) {
            synchronized (RedPointManager.class) {
                if (instance == null) {
                    instance = new RedPointManager();
                }
            }
        }
        return instance;
    }

    private boolean hasXKMsg;
    private boolean hasShopMsg;
    private boolean hasUnionMsg;
    private boolean hasMainMsg;

    private boolean lastXKMsg;
    private boolean lastShopMsg;
    private boolean lastUnionMsg;
    private boolean lastMainMsg;

    /**
     * 如果有不同的消息状态,发送事件
     * 多次重复事件,只发送一次给RN
     */
    public boolean shouldEmitEvent() {
        return hasMainMsg != lastMainMsg || hasXKMsg != lastXKMsg || hasShopMsg != lastShopMsg || hasUnionMsg != lastUnionMsg;
    }

    public void setLastMsgStatus() {
        lastMainMsg = hasMainMsg;
        lastShopMsg = hasShopMsg;
        lastUnionMsg = hasUnionMsg;
        lastXKMsg = hasXKMsg;
    }

    public boolean isHasXKMsg() {
        return hasXKMsg;
    }

    public void setHasXKMsg(boolean hasXKMsg) {
        this.hasXKMsg = hasXKMsg;
    }

    public boolean isHasShopMsg() {
        return hasShopMsg;
    }

    public void setHasShopMsg(boolean hasShopMsg) {
        this.hasShopMsg = hasShopMsg;
    }

    public boolean isHasUnionMsg() {
        return hasUnionMsg;
    }

    public void setHasUnionMsg(boolean hasUnionMsg) {
        this.hasUnionMsg = hasUnionMsg;
    }

    public boolean isHasMainMsg() {
        return hasMainMsg;
    }

    public void setHasMainMsg(boolean hasMainMsg) {
        this.hasMainMsg = hasMainMsg;
    }
}
