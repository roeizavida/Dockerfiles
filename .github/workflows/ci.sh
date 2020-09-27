#!/bin/bash

# Args
github_sha=$1
docker_hub_username=$2
docker_hub_password=$3

# Get changed Dockerfiles
github_files=$(git diff-tree --no-commit-id --name-only --diff-filter=d -r ${github_sha} | grep Dockerfile)

# If there are any changed Dockerfiles
if [[ ! -z ${github_files} ]]
then
  # Login to Docker Hub
  docker login -u ${docker_hub_username} -p ${docker_hub_password}
  # For each changed Dockerfile
  for file in ${github_files[@]}
  do
    # Get the name of the image from the Dockerfile name
    image_name=$(echo ${file} | awk -F '/' '{print $1}')
    # Get the metadata file path
    image_metadata_file=$(echo ${file} | sed -e 's/\.Dockerfile/\.json/g')
    # Get the image tags
    image_tags=$(cat ${image_metadata_file} | jq -r '.tags[]')
    # For each tag in metadata file
    for tag in ${image_tags[@]}
    do
      # Get image full name (for tag)
      image_fullname="${docker_hub_username}/${image_name}:${tag}"
      # Build the docker image
      docker build ${image_name}/ \
        --file ${file} \
        --tag ${image_fullname}
      # Push the docker image to Docker Hub
      docker push ${image_fullname}
    done
  done
  # Logout from Docker Hub
  docker logout
else
  echo "No Dockerfile was changed."
fi