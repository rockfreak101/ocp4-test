# set proxy config via profie.d - should apply for all users
# 
PROXY_URL="http://87.254.212.120:8080"

export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export ftp_proxy="$PROXY_URL"
export no_proxy="127.0.0.1,localhost,.local,nokia.com,alu.com"

# For curl
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export FTP_PROXY="$PROXY_URL"
export NO_PROXY="127.0.0.1,localhost,.local,nokia.com,alu.com"
