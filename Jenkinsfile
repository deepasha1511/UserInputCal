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
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan \
                      -var "client_id=$ARM_CLIENT_ID" \
                      -var "client_secret=$ARM_CLIENT_SECRET" \
                      -var "tenant_id=$ARM_TENANT_ID" \
                      -var "subscription_id=$ARM_SUBSCRIPTION_ID"
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                terraform apply -auto-approve \
                  -var "client_id=$ARM_CLIENT_ID" \
                  -var "client_secret=$ARM_CLIENT_SECRET" \
                  -var "tenant_id=$ARM_TENANT_ID" \
                  -var "subscription_id=$ARM_SUBSCRIPTION_ID"
                '''
            }
        }

        stage('Build .NET App') {
            steps {
                dir('UserInputCal') {
                    sh 'dotnet publish -c Release -o publish'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                sh '''
                zip -r publish.zip UserInputCal/publish/
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
