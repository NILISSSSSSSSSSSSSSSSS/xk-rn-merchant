#!/bin/sh
DINGTALK_ACCESSTOKEN="https://oapi.dingtalk.com/robot/send?access_token=02908b59b1f0e086f9e2f50e132feca6d4795ed4aa754d33aa67881d026f7a51"
TIME_FORMAT="%Y-%m-%d %H:%M:%S"

START_TIME=`cat $TASK_TIME_FILE`
END_TIME=`date +"$TIME_FORMAT"`
START_TIMESTAMP=$(date -j -f "$TIME_FORMAT" "$START_TIME" +%s);
END_TIMESTAMP=$(date -j -f "$TIME_FORMAT" "$END_TIME" +%s);
TASK_TIME=$((END_TIMESTAMP-START_TIMESTAMP));

CONTENT="#### 商联App打包服务 \n> 【环境名称】测试环境 \n\n> 【构建方式】xcbuild \n\n> 【构建编号】${START_TIMESTAMP} \n\n>【构建结果】成功 \n\n> 【开始时间】${START_TIME} \n\n> 【结束时间】${END_TIME} \n\n> 【任务耗时】${TASK_TIME}s \n\n> 【下载二维码】 \n\n> ![screenshot](https://www.pgyer.com/app/qrcode/HRbY) \n\n> 【下载地址】[点击查看](https://www.pgyer.com/V74s) \n\n"

curl $DINGTALK_ACCESSTOKEN \
-H 'Content-Type: application/json' \
-d "{\"msgtype\": \"markdown\",\"markdown\": {\"title\":\"商联测试服\",\"text\": \"${CONTENT}\"},\"at\": {\"atMobiles\": [\"13648091632\",], \"isAtAll\": true}}"
