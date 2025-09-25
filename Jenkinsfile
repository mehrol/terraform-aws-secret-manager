pipeline {
    agent any
    tools {
        git 'Default'  // Make sure Git is configured in Jenkins global tools
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Select environment')
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')

        // Dev secrets
        string(name: 'SECRET_DEV', defaultValue: 'test/dev-db', description: 'Secret Name (Dev)')
        string(name: 'DB_USERNAME_DEV', defaultValue: 'vikrant', description: 'Database Username (Dev)')
        password(name: 'DB_PASSWORD_DEV', defaultValue: 'mypass123', description: 'Database Password (Dev)')

        // QA secrets
        string(name: 'SECRET_QA', defaultValue: 'test/qa-db', description: 'Secret Name (QA)')
        string(name: 'DB_USERNAME_QA', defaultValue: 'qa_user', description: 'Database Username (QA)')
        password(name: 'DB_PASSWORD_QA', defaultValue: 'qaPass123', description: 'Database Password (QA)')
    }

    environment {
        TF_VAR_aws_region  = "${params.AWS_REGION}"
        TF_VAR_environment = "${params.ENV}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Select Secret Vars') {
            steps {
                script {
                    if (params.ENV == 'dev') {
                        env.TF_VAR_secret_name   = params.SECRET_DEV
                        env.TF_VAR_secret_values = "{\"username\":\"${params.DB_USERNAME_DEV}\",\"password\":\"${params.DB_PASSWORD_DEV}\"}"
                    } else if (params.ENV == 'qa') {
                        env.TF_VAR_secret_name   = params.SECRET_QA
                        env.TF_VAR_secret_values = "{\"username\":\"${params.DB_USERNAME_QA}\",\"password\":\"${params.DB_PASSWORD_QA}\"}"
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat """
                terraform plan -input=false -var-file="envs/${params.ENV}.tfvars" ^
                  -var "aws_region=%TF_VAR_aws_region%" ^
                  -var "environment=%TF_VAR_environment%" ^
                  -var "secret_name=%TF_VAR_secret_name%" ^
                  -var "secret_values=%TF_VAR_secret_values%"
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                bat """
                terraform apply -auto-approve -input=false -var-file="envs/${params.ENV}.tfvars ^
                  -var "aws_region=%TF_VAR_aws_region%" ^
                  -var "environment=%TF_VAR_environment%" ^
                  -var "secret_name=%TF_VAR_secret_name%" ^
                  -var "secret_values=%TF_VAR_secret_values%"
                """
            }
        }
    }

    post {
        success {
            echo "✅ Terraform apply completed successfully!"
        }
        failure {
            echo "❌ Terraform apply failed!"
        }
    }
}
