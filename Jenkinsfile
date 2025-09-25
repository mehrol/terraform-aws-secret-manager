pipeline {
    agent any
    tools {
        git 'Default'  // Ensure Git is configured in Jenkins global tools
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
        TFVARS_FILE        = "env/${params.ENV}.tfvars"  // path to auto tfvars
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Generate TFVARS') {
            steps {
                script {
                    def secretName = ""
                    def secretValues = ""
                    
                    if (params.ENV == 'dev') {
                        secretName = params.SECRET_DEV
                        secretValues = "{\"username\":\"${params.DB_USERNAME_DEV}\",\"password\":\"${params.DB_PASSWORD_DEV}\"}"
                    } else if (params.ENV == 'qa') {
                        secretName = params.SECRET_QA
                        secretValues = "{\"username\":\"${params.DB_USERNAME_QA}\",\"password\":\"${params.DB_PASSWORD_QA}\"}"
                    }

                    // Create or overwrite tfvars file
                    bat """
                    echo secret_name = \\"${secretName}\\" > %TFVARS_FILE%
                    echo secret_values = '${secretValues}' >> %TFVARS_FILE%
                    """
                    
                    echo "✅ TFVARS file generated at %TFVARS_FILE%"
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
