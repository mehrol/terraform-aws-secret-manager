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
        string(name: 'SECRET_USERNAME', defaultValue: 'abhi', description: 'Secret Username')
        password(name: 'SECRET_PASSWORD', defaultValue: 'mypass1234', description: 'Secret Password')
    }

    environment {
        TFVARS_FILE = "envs/${params.ENV}.tfvars"
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
                    def tfvarsFile = "envs/${params.ENV}.tfvars"
                    def content = """aws_region   = "${params.AWS_REGION}"
        environment  = "${params.ENV}"
        secret_name  = "${params.SECRET_NAME}"
        secret_values = {
        username = "${params.SECRET_USERNAME}"
        password = "${params.SECRET_PASSWORD}"
        }
        """
                    writeFile file: tfvarsFile, text: content
                    echo "✅ TFVARS file updated at ${tfvarsFile}"
                }
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init -input=false'
            }
        }


        stage('AWS Configure') {
        steps {
        withCredentials([
            string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            bat """
            aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%
            aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%
            aws configure set default.region ${params.AWS_REGION}
            """
        }
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
