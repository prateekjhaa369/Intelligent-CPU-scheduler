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
                bat 'docker build -t devops-app .'
            }
        }
        stage('Run Container') {
            steps {
                bat 'docker run --rm devops-app'
            }
        }
    }
}
