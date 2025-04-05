pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-username/UserInputCal.git'
            }
        }

        stage('Build') {
            steps {
                bat '"C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\MSBuild\\Current\\Bin\\MSBuild.exe" UserInputCal.sln /p:Configuration=Release'
            }
        }

        stage('Publish Artifact') {
            steps {
                archiveArtifacts artifacts: '**/bin/Release/**', fingerprint: true
            }
        }

        stage('Deploy to Azure') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }
    }
}
