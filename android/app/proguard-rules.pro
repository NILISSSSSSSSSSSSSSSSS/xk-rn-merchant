# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
-keep class com.tencent.mm.sdk.** {
   *;
}

-keep class com.alipay.android.app.IAlixPay{*;}
-keep class com.alipay.android.app.IAlixPay$Stub{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback$Stub{*;}
-keep class com.alipay.sdk.app.PayTask{ public *;}
-keep class com.alipay.sdk.app.AuthTask{ public *;}

################################################################################
####################  mi_push
################################################################################
-dontwarn com.xiaomi.push.**
-keep class com.xiaomi.** {*;}

################################################################################
####################  hw_push
################################################################################
-ignorewarning
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes Signature
# hmscore-support: remote transport
-keep class * extends com.huawei.hms.core.aidl.IMessageEntity { *; }
# hmscore-support: remote transport
-keepclasseswithmembers class * implements com.huawei.hms.support.api.transport.DatagramTransport {
<init>(...); }
# manifest: provider for updates
-keep public class com.huawei.hms.update.provider.UpdateProvider { public *; protected *; }

################################################################################
####################  mz_push
################################################################################
-dontwarn com.meizu.cloud.**
-keep class com.meizu.cloud.** {*;}


################################################################################
####################  netease Proguard Rules
################################################################################
-dontwarn com.netease.**
-keep class com.netease.**{*;}
-dontwarn org.apache.lucene.**
-keep class org.apache.lucene.** {*;}
-keepclassmembers class ** {
    public void onEvent*(**);
    void onEvent*(**);
}

################################################################################
####################  weibo
################################################################################
-keep class com.sina.weibo.sdk.** { *; }