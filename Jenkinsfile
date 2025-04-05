pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/deepasha1511/UserInputCal.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat '''
                    terraform plan ^
                      -var="client_id=%ARM_CLIENT_ID%" ^
                      -var="client_secret=%ARM_CLIENT_SECRET%" ^
                      -var="tenant_id=%ARM_TENANT_ID%" ^
                      -var="subscription_id=%ARM_SUBSCRIPTION_ID%"
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                bat '''
                terraform apply -auto-approve ^
                  -var="client_id=%ARM_CLIENT_ID%" ^
                  -var="client_secret=%ARM_CLIENT_SECRET%" ^
                  -var="tenant_id=%ARM_TENANT_ID%" ^
                  -var="subscription_id=%ARM_SUBSCRIPTION_ID%"
                '''
            }
        }

        stage('Build .NET Application') {
            steps {
                bat '"C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\MSBuild\\Current\\Bin\\MSBuild.exe" UserInputCal.sln /p:Configuration=Release'
            }
        }

        stage('Package Application') {
            steps {
                bat '''
                powershell Compress-Archive -Path bin\\Release\\* -DestinationPath publish.zip -Force
                '''
            }
        }

        stage('Deploy to Azure') {
            steps {
                bat '''
                az webapp deployment source config-zip --resource-group UserInputCalRG --name UserInputCalApp --src publish.zip
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
