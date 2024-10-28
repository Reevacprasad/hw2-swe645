pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker')  // Retrieves both username and password
    }
    stages {
        stage("Build Survey Image") {
            steps {
                script {
                    // Fetch the current SCM and print the timestamp
                    checkout scm
                    sh 'echo ${BUILD_TIMESTAMP}'
                    
                    // Correctly login to DockerHub using the username and password
                    sh 'docker login -u rprasad6 -p ${DOCKERHUB_CREDENTIALS}'
                    
                    // Build the Docker image
                    def customImage = docker.build("rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}")
                }
            }
        }
        stage("Push img to docker hub") {
            steps {
                script {
                    // Push the Docker image to DockerHub
                    sh 'docker push rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}'
                }
            }
        }
        stage("Deploy to kubernetes") {
            steps {
                script {
                    // Deploy the image to Kubernetes
                    sh 'kubectl set image deployment/container-hw2 container-hw2=rprasad6/docker-img-hw2:${BUILD_TIMESTAMP} -n default'
                }
            }
        }
    }
}
