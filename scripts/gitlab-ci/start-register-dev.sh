curl -X POST \
     -F token=a05622e91d1951dd318deb2d70686f \
     -F "ref=dev" \
     -F "variables[BUILD_ENVIR]=dev" \
     -F "variables[BUILD_ENVIR_NAME]=开发" \
     -F "variables[DINGTALK_ACCESSTOKEN]=ebc09b87afacaeff1830322d7f5995b6d1bdfb8980d4ebc2f8711eb683d61496" \
     -F "variables[PGYER_API_TOKEN]=78c83aa2cc2846845ff30092040a3b3a" \
     -F "variables[PGYER_ID]=ywvQ" \
     http://192.168.2.201/api/v4/projects/21/trigger/pipeline