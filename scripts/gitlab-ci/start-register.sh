curl -X POST \
     -F token=a05622e91d1951dd318deb2d70686f \
     -F "ref=dev" \
     -F "variables[BUILD_ENVIR]=test" \
     -F "variables[BUILD_ENVIR_NAME]=测试" \
     -F "variables[DINGTALK_ACCESSTOKEN]=02908b59b1f0e086f9e2f50e132feca6d4795ed4aa754d33aa67881d026f7a51" \
     -F "variables[PGYER_API_TOKEN]=d2b300d2d73a036434e36545c81c5b4b" \
     -F "variables[PGYER_ID]=V74s" \
     http://192.168.2.201/api/v4/projects/21/trigger/pipeline