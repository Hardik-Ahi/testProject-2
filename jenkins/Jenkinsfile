pipeline {
    agent any
    options {
        timeout(time: 20, unit: 'MINUTES')
    }
    stages {
        stage('Checkout repo') {
            steps {
                checkout scmGit(
                branches: [[name: 'master']],
                userRemoteConfigs: [[url: 'https://github.com/Hardik-Ahi/testProject-2.git']]
                )
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t html:latest .'
                sh 'docker tag html:latest ahihardik11/html'
                sh 'docker push ahihardik11/html:latest'
            }
        }
        stage('Terraform infrastructure') {
            steps {
                sh 'cd terraform && terraform init && terraform apply --auto-approve'
            }
        }
    }
}
