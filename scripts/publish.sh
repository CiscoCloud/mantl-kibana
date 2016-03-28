set -xe

repo=ciscocloud
version=${TRAVIS_TAG:-edge}

docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
docker build -t $repo/mantl-kibana:$version --rm .
docker push $repo/mantl-kibana:$version
