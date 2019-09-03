package com.xkshop.scan;

/**
 * @author FanCoder.LCY
 * @date 2018/8/15 14:57
 * @email 15708478830@163.com
 * @desc 约束类, 用于约束 APP 基本信息.
 * <p>
 * PS : 为管理多个 Model 采用契约模式定义常量.
 * PS : 为了简化调用链采用拼音首字母缩写形式.
 * PS : 为了规范常量,采用大写形式.
 **/
@SuppressWarnings({"JavaDoc", "unused"})
public class CONSTRAINT {
    /**
     * 全局常量
     */
    public static final class GLOBAL {
        public static final String HOST = "http://gc.xksquare.com/";

        public static final String DATABASE_NAME = "xkgc.db";
        // 本地数据库名
        public static final String PREFERENCE_FILE_NAME = "sksl_preference_file";
        // sharepreference文件名

        public static final String SCAN_RESULT_KEY = "xksl_scan_result";
        //扫码结果key
        public static final String ROUTER_CHROME_HOME = "xksl://shuimukeji.cn";
        //router  chrome +home

        public static final int PAGE_NO_FROM_INDEX = 1;
        public static final int PAGE_NEXT_FROM_INDEX = 2;
        public static final int PAGE_SIZE_FOR_REQUEST = 10;
        public static final int TYPE_SELECT = 0x001;

    }

    public static final class QRCODE {

        /***********************************HOST***************************************************/

        /**
         * 晓可广场协议头
         **/
        public static final String PROTOCOL_XKGC = "xkgc";
        /**
         * 晓可商联协议头
         **/
        public static final String PROTOCOL_XKSL = "xksl";

        /**
         * 可友主页 Host
         **/
        public static final String HOST_XK_FRIENDS_HOME = "business_card";

        /***
         * 可友群聊群id PARAMS key
         */
        public static final String PARAMS_KEY_GROUPID = "groupId";

        /***
         * 晓可群聊(需要加群) Host
         */
        public static final String HOST_XK_GROUP_CHAT = "group_business_card";

        /**
         * 商家扫码顾客消费码
         */
        public static final String OFFLINE_CONSUMPTION_ORDER = "offline_consumption_order";
    }

    /**
     * 页面传参
     */
    public static final class EXTRA {
        public static final String EXTRA_DATA = "extra_data";
        public static final String EXTRA_BLACKLIST_TITLE = "extra_blacklist_title";
        public static final String EXTRA_BLOCKLIST_TITLE = "extra_blocklist_title";
        public static final String EXTRA_ADDRESS_TYPE = "extra_address_type";
        public static final String EXTRA_ADDRESS_MODIFY = "extra_address_modify";
        public static final String EXTRA_RECEIPT_TYPE = "extra_receipt_type";
        public static final String EXTRA_COLLECTION_TYPE = "extra_collection_type";
        public static final String EXTRA_EDIT_NICKNAME = "extra_edit_nickname";
        public static final String EXTRA_EDIT_SIGNATURE = "extra_edit_signature";
        public static final String EXTRA_ADDRESS_SELECT = "extra_address_select";
    }

    /**
     * 数据缓存
     */
    public static final class CACHE {
        public static final String KEY_SAVE_USER = "KEY_SAVE_USER";
    }

    /**
     * 扫码
     */
    public static final class SCAN {
        public static final class PATH {
            public static final String SCAN_PATH = "/scan/common";                              // 扫码路由
        }

        //参数
        public static final class EXTRA {
            public static final String BARCODE_IMAGE_ENABLED = "BARCODE_IMAGE_ENABLED";         //是否保存图片
            public static final String BEEP_ENABLED = "BEEP_ENABLED";                           //是否播放bi的声音
            public static final String CAMERA_ID = "SCAN_CAMERA_ID";                            //摄像头id
            public static final String IS_ONCE = "SCAN_ONCE";                                   //是否是一次性扫描，多次不会自动关闭界面
            public static final String OPERATION_FLAG = "operation_flag";                       //与扫码功能无关，业务标识用于回掉界面处理业务逻辑 , int 类型,默认为0
            public static final String OPERATION_DATA = "operation_data";                       //与扫码功能无关，业务数据实体 需要使用java序列化,功能与 OPERATION_FLAG 协同处理业务逻辑
        }
    }

    /**
     * Router Path
     */
    public static final class PATH {
        /**
         * Base Model
         */
        public static final class BASE {
            public static final String BASE_SCAN_RESULT_ACT = "/base/scan";
        }

        /**
         * COMM Model
         */
        public static final class COMM {
            public static final String COMM_GALLERY = "/comm/gallery";
            public static final String OTHER_INFO = "/other/info";      //个人资料页
            public static final String COMM_SCAN = "/scan/common";      //扫一扫
        }


    }
}
