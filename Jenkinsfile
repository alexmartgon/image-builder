podTemplate(label: 'docker',
    containers: [
        containerTemplate(
            name: 'docker', 
            image: 'docker:latest',
            ttyEnabled: true,
            envVars: [ 
                secretEnvVar(key: "USERNAME", secretName: "docker-access-key", secretKey: "USERNAME"),
                secretEnvVar(key: "PASSWORD", secretName: "docker-access-key", secretKey: "PASSWORD"),
            ]
    )]) {
    node('docker') {
        // Checkout stage for pulling the git repository
        stage('Checkout') {
            echo 'Checking out SCM from Git Repo.'
            checkout scm
        }

        stage('Build') {
            container('docker'){
                sh '''
                    #!/bin/bash

                    ### Check configuration file exists if it doesnt exit.
                    if [ -f "build.env" ]; then
                        source build.env
                    else
                        echo "Configuration build file not found!"
                        exit 1
                    fi

                    ### Check all required vars are set
                    if [ -z "$BUILDDOCKERFILE" ] || [ -z "$REPO" ] || [-z "$TAG"]; then
                        echo "Not all environment variables were set in the env file."
                        exit 1
                    fi

                    DOCKER_IMAGE="$DOCKER_REPO:$DOCKER_TAG"

                    ### Check dockerfile exists 
                    if [ -f $BUILDDOCKERFILE]; then
                        mkdir build
                        cp $BUILDDOCKERFILE build/Dockerfile
                        
                        ### Perform docker login build and push
                        docker login -u $USERNAME -p $PASSWORD

                        if [ $? -eq 0 ]; then
                            echo "Log in successful"
                        else
                            echo "Failed to log in to DockerHub"
                            exit 1
                        fi

                        docker buildx build -t="$DOCKER_IMAGE" build

                        if [ $? -eq 0 ]; then
                            echo "Docker image built successfully!"
                        else
                            echo "Failed to build Docker image: $DOCKER_IMAGE."
                            exit 1
                        fi

                        docker push "$DOCKER_IMAGE"

                        if [ $? -eq 0 ]; then
                            echo "Docker image pushed successfully!"
                        else
                            echo "Failed to push Docker image: $DOCKER_IMAGE."
                            exit 1
                        fi
                    else
                        echo "Cannot validate $BUILDDOCKERFILE exists"
                        exit 1
                    fi
                '''
            }
        }
    }
}