set -xe

repo=ciscocloud
version=${TRAVIS_TAG:-edge}

docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
docker build -t $repo/mantl-kibana:$version --rm .
docker push $repo/mantl-kibana:$version

if [ "$version" != 'edge' ]; then
    docker tag $repo/mantl-kibana:$version $repo/mantl-kibana:latest
    docker push $repo/mantl-kibana:latest
fi
