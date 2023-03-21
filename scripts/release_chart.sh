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

CHART_NAME=$(grep name: $CHART_PATH/Chart.yaml | awk '{print $2}' | head -n1)
CHART_VERSION=$(grep version: $CHART_PATH/Chart.yaml | awk '{print $2}' | head -n1)

echo "checking out release branch"
git checkout release
echo "git add $CHART_NAME-$CHART_VERSION.tgz"
git add $CHART_NAME-$CHART_VERSION.tgz
echo "git commit -m "release: $CHART_NAME-$CHART_VERSION""
git commit -m "release: $CHART_NAME-$CHART_VERSION"
echo "pull and rebase release branch"
git pull --rebase
echo "git push origin release"
git push origin release
git checkout main
