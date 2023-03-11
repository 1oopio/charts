#/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <path to chart>"
    exit 1
fi

CHART_PATH=$1

if [ ! -d "$CHART_PATH" ]; then
    echo "Chart path $CHART_PATH does not exist"
    exit 1
fi

if [ ! -f "$CHART_PATH/Chart.yaml" ]; then
    echo "Chart path $CHART_PATH does not contain a Chart.yaml file"
    exit 1
fi

helm package $CHART_PATH

CHART_NAME=$(grep name: $CHART_PATH/Chart.yaml | awk '{print $2}')
CHART_VERSION=$(grep version: $CHART_PATH/Chart.yaml | awk '{print $2}')

git checkout release
git add $CHART_NAME-$CHART_VERSION.tgz
git commit -m "release: $CHART_NAME-$CHART_VERSION"
git pull --rebase
git push origin release
git checkout main
