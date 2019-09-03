curl -X POST \
     -F token=a05622e91d1951dd318deb2d70686f \
     -F "ref=master" \
     -F "variables[BUILD_ENVIR]=beta" \
     -F "variables[BUILD_ENVIR_NAME]=预发布" \
     -F "variables[DINGTALK_ACCESSTOKEN]=02908b59b1f0e086f9e2f50e132feca6d4795ed4aa754d33aa67881d026f7a51" \
     -F "variables[PGYER_API_TOKEN]=b6923bcd6a8f665d9702555f8f3d88c0" \
     -F "variables[PGYER_ID]=CUGA" \
     http://192.168.2.201/api/v4/projects/21/trigger/pipeline