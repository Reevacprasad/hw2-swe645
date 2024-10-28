pipeline {
	agent any
	environment {
		DOCKERHUB_PASS = credentials('docker')
	}
	stages {
		stage("Build Survey Image") {
			steps {
				script {
					checkout scm
					sh 'echo ${BUILD_TIMESTAMP}'
					sh 'docker login -u rprasad6 -p Ree9969177492/ }'
					def customImage = docker.build("rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}")
				}
			}
		}
		stage("Push img to docker hub") {
			steps {
				script {
					sh 'docker push rprasad6/docker-img-hw2:${BUILD_TIMESTAMP}'
				}
			}
		}
		stage("Deploy to kubernetes") {
			steps {
				sh 'kubectl set image deployment/container-hw2 container-hw2=rprasad6/docker-img-hw2:${BUILD_TIMESTAMP} -n default'
			}
		}
	}
}