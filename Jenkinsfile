pipeline {
    agent any
    parameters {
        checkout scmGit(
            branches: [[name: 'master']],
            userRemoteConfigs: [[url: 'https://github.com/Hardik-Ahi/testProject-2.git']]
        )
    }
    options {
        timeout(time: 20, unit: 'MINUTES')
    }
    stages {
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t html:latest .'
                bat 'docker tag html:latest ahihardik11/html'
                bat 'docker push ahihardik11/html:latest'
            }
        }
        stage('Terraform infrastructure') {
            steps {
                bat 'cd terraform && terraform init && terraform apply --auto-approve'
            }
        }
    }
}
