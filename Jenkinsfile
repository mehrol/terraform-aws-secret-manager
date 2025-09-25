pipeline {
    agent any
    tools {
        git 'Default'  // Make sure Git is configured in Jenkins global tools
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa'], description: 'Select environment')
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')

        // Secrets from Jenkins (not in code)
        string(name: 'SECRET_NAME', defaultValue: 'test/dev-db', description: 'Secret Name')
        string(name: 'SECRET_USERNAME', defaultValue: 'vikrant', description: 'Secret Username')
        password(name: 'SECRET_PASSWORD', defaultValue: 'mypass123', description: 'Secret Password')
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

        stage('Overwrite TFVARS with Jenkins Secrets') {
            steps {
                script {
                    // Overwrite tfvars file dynamically
                    bat """
                    echo aws_region   = \\"${params.AWS_REGION}\\" > %TFVARS_FILE%
                    echo environment  = \\"${params.ENV}\\" >> %TFVARS_FILE%
                    echo secret_name  = \\"${params.SECRET_NAME}\\" >> %TFVARS_FILE%
                    echo secret_values = { >> %TFVARS_FILE%
                    echo   username = \\"${params.SECRET_USERNAME}\\" >> %TFVARS_FILE%
                    echo   password = \\"${params.SECRET_PASSWORD}\\" >> %TFVARS_FILE%
                    echo } >> %TFVARS_FILE%
                    """
                    echo "✅ TFVARS file updated dynamically from Jenkins parameters: %TFVARS_FILE%"
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
