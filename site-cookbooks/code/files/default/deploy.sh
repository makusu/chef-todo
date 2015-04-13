#!/bin/sh
echo "=========="
echo $(date)
echo "=========="

if [ $# -eq 1 ]; then
    echo "Deploying tag $1"
    cd /var/www/api-todo && git remote update && git checkout tags/$1
    echo "Deployment Done!"
else
    echo "Tag was not defined"
fi

echo "=========="
echo ""
