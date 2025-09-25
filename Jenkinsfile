pipeline {
    agent any
    tools {
        git 'Default'
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Select environment')
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')
        string(name: 'SECRET_DEV', defaultValue: 'test/dev-db', description: 'Secret Name')
        string(name: 'SECRET_QA', defaultValue: 'test/qa-db', description: 'Secret Name1')
        string(name: 'DB_USERNAME_DEV', defaultValue: 'vikrant', description: 'Database Username')
        password(name: 'DB_PASSWORD_DEV', defaultValue: 'mypass123', description: 'Database Password')
    }

    environment {
        TF_VAR_aws_region   = "${params.AWS_REGION}"
        TF_VAR_environment  = "${params.ENV}"
        TF_VAR_secret_name  = "${params.SECRET_DEV}"
        TF_VAR_secret_values = "{\"username\":\"${params.DB_USERNAME_DEV}\",\"password\":\"${params.DB_PASSWORD_DEV}\"}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                  terraform init -input=false
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                  terraform plan -input=false \
                    -var "aws_region=$TF_VAR_aws_region" \
                    -var "environment=$TF_VAR_environment" \
                    -var "secret_name=$TF_VAR_secret_name" \
                    -var "secret_values=$TF_VAR_secret_values"
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                  terraform apply -auto-approve -input=false \
                    -var "aws_region=$TF_VAR_aws_region" \
                    -var "environment=$TF_VAR_environment" \
                    -var "secret_name=$TF_VAR_secret_name" \
                    -var "secret_values=$TF_VAR_secret_values"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Terraform apply successful!"
        }
        failure {
            echo "❌ Terraform apply failed!"
        }
    }
}
