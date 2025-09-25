pipeline {
    agent any
    tools {
        git 'Default'  // Make sure Git is configured
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Select environment')
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')

        // Dev secrets
        string(name: 'SECRET_DEV', defaultValue: 'test/dev-db', description: 'Secret Name (Dev)')
        string(name: 'DB_USERNAME_DEV', defaultValue: 'dev_user', description: 'Database Username (Dev)')
        password(name: 'DB_PASSWORD_DEV', defaultValue: 'dev_pass', description: 'Database Password (Dev)')

        // QA secrets
        string(name: 'SECRET_QA', defaultValue: 'test/qa-db', description: 'Secret Name (QA)')
        string(name: 'DB_USERNAME_QA', defaultValue: 'qa_user', description: 'Database Username (QA)')
        password(name: 'DB_PASSWORD_QA', defaultValue: 'qa_pass', description: 'Database Password (QA)')
    }

    environment {
        TFVARS_FILE = "env/${params.ENV}.tfvars"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Update TFVARS File') {
            steps {
                script {
                    def secretName = "test/dev-db"
                    def username = "vikrant"
                    def password = "mypass123"

                    if (params.ENV == 'dev') {
                        secretName = params.SECRET_DEV
                        username   = params.DB_USERNAME_DEV
                        password   = params.DB_PASSWORD_DEV
                    } else if (params.ENV == 'qa') {
                        secretName = params.SECRET_QA
                        username   = params.DB_USERNAME_QA
                        password   = params.DB_PASSWORD_QA
                    }

                    // Overwrite existing tfvars file
                    bat """
                    echo aws_region   = \\"${params.AWS_REGION}\\" > %TFVARS_FILE%
                    echo environment  = \\"${params.ENV}\\" >> %TFVARS_FILE%
                    echo secret_name  = \\"${secretName}\\" >> %TFVARS_FILE%
                    echo secret_values = { >> %TFVARS_FILE%
                    echo   username = \\"${username}\\" >> %TFVARS_FILE%
                    echo   password = \\"${password}\\" >> %TFVARS_FILE%
                    echo } >> %TFVARS_FILE%
                    """

                    echo "✅ TFVARS file updated at %TFVARS_FILE%"
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
                terraform plan -input=false -var-file="%TFVARS_FILE%"
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                bat """
                terraform apply -auto-approve -input=false -var-file="%TFVARS_FILE%"
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
