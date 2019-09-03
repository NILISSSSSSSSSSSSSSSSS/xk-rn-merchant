package com.xkshop.net.upload;


import java.io.File;

public class UploadUtils {

    /*    public static void upLoadVideo(final Promise promise, String qiniuToken) {
            UploadManager uploadManager = new UploadManager();
            String key = null;
            String token = <从服务端SDK获取 >;
            uploadManager.put(filePath, key, token,
                new UpCompletionHandler() {
                    @Override
                    public void complete(String key, ResponseInfo info, JSONObject res) {
                        if (info.isOK()) {
                            promise.resolve(key);
                            Log.i("qiniu", "Upload Success");
                        } else {
                            Log.i("qiniu", "Upload Fail");
                        }

                    }
                }, null);

        }*/
//    public static Zone createZone() {
//        String upIp = "220.166.65.68:80";
//        String upIp2 = "106.38.227.28";
//        String[] upIps = {upIp, upIp2};
//        ServiceAddress up = new ServiceAddress("http://" + "upload-z2.qiniu.com", upIps);
//        ServiceAddress upBackup = new ServiceAddress("http://" + "up-z2.qiniu.com", upIps);
//        return new Zone(up, upBackup);
    // }

    /**
     * 上传视频是否超出最大50M限制
     *
     * @param filePath 视频路径
     * @param overSize 视频大小限制 单位kb
     * @return
     */
    public static boolean isOverSize(String filePath, int overSize) {
        File file = new File(filePath);
        if (file.exists() && file.isFile()) {
            return file.length() > overSize * 1024;
        } else {
            return true;
        }
    }
}
