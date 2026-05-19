pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/<username>/<project>.git'
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-app .'
            }
        }
        stage('Run Container') {
            steps {
                sh 'docker run -d -p 3000:3000 devops-app'
            }
        }
    }
}
