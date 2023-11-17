function __docker_clean_all
    # Remove containers
    set containers (docker ps -aq)
    if [ -n "$containers" ]
        docker rm -vf $containers
    else
        echo "No containers to remove."
    end

    # Remove images
    set images (docker images -aq)
    if [ -n "$images" ]
        docker rmi -f $images
    else
        echo "No images to remove."
    end

    # Docker system prune
    echo "Cleaning Docker system..."
    docker system prune --all --force --volumes
end
