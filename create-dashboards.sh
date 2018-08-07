#!/bin/bash

HOST=nimbusserver.aos.com
PORT=8085
SHAREDSPACE=1001
WORKSPACE=1002
DEBUG=false

function usage()
{
   echo "Create Dashboards will create a list of favorite dashboards based"
   echo "on the json file in the favorites directory"
   echo ""
   echo "./create-dashboards.sh"
   echo -e "\t-h --help"
   echo -e "\t-d --debug - dispalys all messages"
   echo -e "\t--host - target Octane host (default: ${HOST})"
   echo -e "\t--port - target Octane port (default: ${PORT})"
   echo -e "\t--sharedspace - target Octane sharedspace (default: ${SHAREDSPACE})"
   echo -e "\t--workspace - target Octane workspace (default: ${WORKSPACE})"
   echo ""
}

while [[ "$1" != "" ]]; do
   PARAM=$1
   VALUE=$2
   case $PARAM in
      -h | --help)
         usage
         exit
         ;;
      -d | --debug)
         DEBUG=true
         ;;
      --host)
         HOST=${VALUE}
         ;;
      --port)
         PORT=${VALUE}
         ;;
      --sharedspace)
         SHAREDSPACE=${VALUE}
         ;;
      --workspace)
         WORKSPACE=${VALUE}
         ;;
   esac
   shift
   shift
done

if [ ${DEBUG} = true ]; then
   ARGS="-v"
else
   ARGS="-s -o /dev/null"
fi

echo -e "Using:\n\r\t${HOST}:${PORT}\n\r\tshared_spaces: ${SHAREDSPACE}\n\r\tworkspaces: ${WORKSPACE}"

curl -c cookies ${ARGS} -X POST http://${HOST}:${PORT}/authentication/sign_in \
   -H 'Content-Type: application/json' \
   -d @credentials.json

echo "Processing:"
for file in favorites/*.json
do
   if [[ -f ${file} ]]; then
      echo -e "\t${file}"
      curl -b cookies ${ARGS} -X POST http://${HOST}:${PORT}/api/shared_spaces/${SHAREDSPACE}/workspaces/${WORKSPACE}/favorites \
         -H 'Content-Type: application/json' \
         -H 'HPECLIENTTYPE: HPE_REST_API_TECH_PREVIEW' \
         -d @${file}
   fi
done

#curl -X GET http://${HOST}:${PORT}/authentication/sign_out \
#   -H 'Content-Type: application/json'
