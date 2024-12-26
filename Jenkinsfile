// podTemplate(label: 'kaniko',
//     containers: [
//         containerTemplate(
//             name: 'kaniko', 
// command
//             image: 'bitnami/kaniko:1.23.2',
//             ttyEnabled: false,
//             args: ["--dockerfile=reverse-dns-lookup.Dockerfile",
//                 "--destination=alexmartgon/jenkins-reverse-dns-lookup:0.0.1",
//                 "--context=git://github.com/alexmartgon/image-builder.git"
//             ],
//             envVars: [ 
//                 secretEnvVar(key: "HOSTED_ZONE_ID", secretName: "homelab-dns", secretKey: "HOSTED_ZONE_ID"),
//                 secretEnvVar(key: "HOSTED_ZONE_RECORD", secretName: "homelab-dns", secretKey: "HOSTED_ZONE_RECORD")
//             ])
//     ],
//     volumes: [secretVolume(secretName: 'docker-access-key', mountPath: '/kaniko/.docker')]
//     ) {
podTemplate(
    label: 'kaniko',
    yaml:'''
        apiVersion: v1
        kind: Pod
        metadata:
          name: kaniko
          namespace: jenkins
        spec:
          containers:
            - name: kaniko
              image: bitnami/kaniko:1.23.2
              args:
              - "--dockerfile=reverse-dns-lookup.Dockerfile"
              - "--context=git://github.com/alexmartgon/image-builder.git"
              - "--destination=alexmartgon/jenkins-reverse-dns-lookup:0.0.1"
              volumeMounts:
              - name: docker-secret
                mountPath: /kaniko/.docker
          restartPolicy: Never
          volumes:
            - name: docker-secret
              secret:
                secretName: reg-creds
                items:
                - key: .dockerconfigjson
                  path: config.json
    ''') {
    node('kaniko') {
        // Checkout stage for pulling the git repository
        stage('Checkout') {
            echo 'Checking out SCM from Git Repo.'
            checkout scm
        }

        stage('Build') {
            container('kaniko'){
                sleep(300)
            }
        }
    }
}



// podTemplate(label: 'docker',
//     containers: [
//         containerTemplate(
//             name: 'docker', 
//             image: 'docker:latest',
//             ttyEnabled: false,
//             envVars: [ 
//                 secretEnvVar(key: "USERNAME", secretName: "docker-access-key", secretKey: "USERNAME"),
//                 secretEnvVar(key: "PASSWORD", secretName: "docker-access-key", secretKey: "PASSWORD"),
//             ],
//             yaml:
//                 securityContext:
//                     allowPrivilegeEscalation: true
//     )]) {
//     node('docker') {
//         // Checkout stage for pulling the git repository
//         stage('Checkout') {
//             echo 'Checking out SCM from Git Repo.'
//             checkout scm
//         }

//         stage('Build') {
//             container('docker'){
//                 sh '''
//                     #!/bin/bash

//                     ### Check configuration file exists if it doesnt exit.
//                     if [ -f "build.env" ]; then
//                         source build.env
//                     else
//                         echo "Configuration build file not found!"
//                         exit 1
//                     fi

//                     ### Check all required vars are set
//                     if [ -z "$BUILDDOCKERFILE" ] || [ -z "$REPO" ] || [-z "$TAG"]; then
//                         echo "Not all environment variables were set in the env file."
//                         exit 1
//                     fi

//                     DOCKER_IMAGE="$DOCKER_REPO:$DOCKER_TAG"

//                     ### Check dockerfile exists 
//                     if [ -f $BUILDDOCKERFILE]; then
//                         mkdir build
//                         cp $BUILDDOCKERFILE build/Dockerfile
                        
//                         ### Perform docker login build and push
//                         docker login -u $USERNAME -p $PASSWORD

//                         if [ $? -eq 0 ]; then
//                             echo "Log in successful"
//                         else
//                             echo "Failed to log in to DockerHub"
//                             exit 1
//                         fi

//                         docker buildx build -t="$DOCKER_IMAGE" build

//                         if [ $? -eq 0 ]; then
//                             echo "Docker image built successfully!"
//                         else
//                             echo "Failed to build Docker image: $DOCKER_IMAGE."
//                             exit 1
//                         fi

//                         docker push "$DOCKER_IMAGE"

//                         if [ $? -eq 0 ]; then
//                             echo "Docker image pushed successfully!"
//                         else
//                             echo "Failed to push Docker image: $DOCKER_IMAGE."
//                             exit 1
//                         fi
//                     else
//                         echo "Cannot validate $BUILDDOCKERFILE exists"
//                         exit 1
//                     fi
//                 '''
//             }
//         }
//     }
// }