environment=$1

if [ -z "$environment" ]; then
  echo "Environment is required"
  exit 1
fi

if [ "$environment" != "uat" ] && [ "$environment" != "testing" ] && [ "$environment" != "prod" ]; then
  echo "Environment must be either uat, testing, or prod"
  exit 1
fi

if [ "$environment" == "prod" ]; then
  target_host="apclassroom.collegeboard.org"
else
  target_host="apclassroom-${environment}.collegeboard.org"
fi

open -na "Google Chrome" --args \
  --proxy-server="127.0.0.1:8089" \
  --proxy-bypass-list="*.learnosity.com;reports-va.learnosity.com;sdk.split.io;cdn.split.io;wistia.com;fast.wistia.net;status.us10.clickhelp.co;cb.academicmerit.com;apc-api-uat.collegeboard.org;apc-api-testing.collegeboard.org;apc-api-production.collegeboard.org" \
  --user-data-dir="/tmp/chrome-mitm" \
  --ignore-certificate-errors \
  "https://${target_host}/login?directlogin=true"
