#本机IP地址 无需填写
IP=
#一卡通号
ID=''
#密码
password=''
#读取json中值
function get_json_value()
{
  local json=$1
  local key=$2

  if [[ -z "$3" ]]; then
    local num=1
  else
    local num=$3
  fi

  local value=$(echo "${json}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'${key}'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p)

#  echo ${value}
  IP=${value}
}

function login_wlan()
{
#get 报文
RESULT=$(curl -k -s https://w.seu.edu.cn/drcom/chkstatus?callback=dr1003)
#echo $RESULT
#得到本机IP
get_json_value $RESULT v46ip
#echo $IP
url="https://w.seu.edu.cn:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C$ID&user_password=$password&wlan_user_ip=$IP"
login="curl $url"
$login
#echo $login
}

while true
do
        if ping -c 1 -w 1 baidu.com >/dev/null;then
            sleep 40m
        else
            login_wlan
        fi
done

