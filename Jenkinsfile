 // Group: Alpha1
 // File: Jenkinsfile
 // Description: To define CI/CD pipeline for Docker Image Buliding and pushing, deploying to Kubernetes cluster

pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker')  // Retrieve DockerHub credentials
        BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}" // Use a timestamp for image tagging
		KUBECONFIG_CREDENTIALS = credentials('kubeconfig')
	}
    stages {
        stage("Build Survey Image") {
            steps {
                script {
                    // Fetch the current SCM and print the timestamp
                    checkout scm
                    sh 'echo ${BUILD_TIMESTAMP}'
                    
                    // Correctly login to DockerHub using the username and password
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    
                    // Build the Docker image
                    def customImage = docker.build("rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}")
                }
            }
        }
        stage("Push img to docker hub") {
            steps {
                script {
                    // Push the Docker image to DockerHub
                    sh "docker push rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}"
                }
            }
        }
        stage("Deploy to kubernetes") {
			steps {
                withEnv(["KUBECONFIG=${KUBECONFIG_CREDENTIALS}"]) {
                    sh 'kubectl set image deployment/deployment container-hw2=rprasad6/docker-img-hw2:${BUILD_TIMESTAMP} -n default'
                }
            }
        }
    }
}