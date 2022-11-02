pipeline {
    agent any
    stages {
        stage('Preparations') {
            steps {
                script {
                    echo "Preparing!"
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo "Testing!"
                }
            }
        }
        stage('Build') {
            when {
                expression { env.BRANCH_NAME == 'master' }
            }
            steps {
                script {
                    dockerImage = docker.build("acme-app:${env.BRANCH_NAME}-${env.BUILD_ID}")
                }
            }
        }
        stage('Push docker image') {
            when {
                expression { env.BRANCH_NAME == 'master' }
            }
            steps {
                script {
                    docker.withRegistry('http://localhost:5000') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
