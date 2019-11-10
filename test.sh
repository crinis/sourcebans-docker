for git_tag in $(git tag); do
  git checkout tags/$git_tag
  docker build -t $IMAGE_REPOSITORY:$git_tag .
  docker push $IMAGE_REPOSITORY:$git_tag
done
