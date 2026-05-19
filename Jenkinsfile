pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                echo 'Source already checked out by Jenkinsfile SCM'
            }
        }
        stage('Build') {
            steps {
                bat 'javac CPUScheduler.java'
            }
        }
        stage('Build Docker Image') {
            steps {
                bat '''
                if not exist .docker-config mkdir .docker-config
                > .docker-config/config.json echo {}
                set DOCKER_CONFIG=%CD%/.docker-config
                call "C:/Program Files/Docker/Docker/resources/bin/docker.exe" build -t devops-app .
                '''
            }
        }
        stage('Run Container') {
            steps {
                bat '''
                set DOCKER_CONFIG=%CD%/.docker-config
                call "C:/Program Files/Docker/Docker/resources/bin/docker.exe" run --rm devops-app
                '''
            }
        }
    }
}
