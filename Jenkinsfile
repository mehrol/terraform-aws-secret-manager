pipeline {
    agent any
    tools {
        git 'Default'  // Make sure Git is configured in Jenkins global tools
    }


    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare tfvars') {
            steps {
                withCredentials([
                string(credentialsId: 'DB_USERNAME', variable: 'DB_USERNAME'),
                string(credentialsId: 'DB_PASSWORD', variable: 'DB_PASSWORD'),
                string(credentialsId: 'STRIPE_SECRET_DIAGNOSTICS', variable: 'STRIPE_SECRET_DIAGNOSTICS'),
                string(credentialsId: 'STRIPE_SECRET_HOLDINGS', variable: 'STRIPE_SECRET_HOLDINGS'),
                string(credentialsId: 'STRIPE_SECRET_WEBHOOK', variable: 'STRIPE_SECRET_WEBHOOK'),
                string(credentialsId: 'WEBHOOK_PWD', variable: 'WEBHOOK_PWD'),
                string(credentialsId: 'WEBHOOK_BT_PASSWORD', variable: 'WEBHOOK_BT_PASSWORD')
                ]) {

                    // Overwrite values dynamically from Jenkins credentials or environment
            sh '''
                sed -i 's|^db_username *=.*|db_username = "${DB_USERNAME}"|' envs/dev.tfvars
                sed -i 's|^db_password *=.*|db_password = "${DB_PASSWORD}"|' envs/dev.tfvars
                sed -i 's|^stripe_secret_diagnostics *=.*|stripe_secret_diagnostics = "${STRIPE_SECRET_DIAGNOSTICS}"|' envs/dev.tfvars
                sed -i 's|^stripe_secret_holdings *=.*|stripe_secret_holdings = "${STRIPE_SECRET_HOLDINGS}"|' envs/dev.tfvars
                sed -i 's|^stripe_secret_webhook *=.*|stripe_secret_webhook = "${STRIPE_SECRET_WEBHOOK}"|' envs/dev.tfvars
                sed -i 's|^webhook_bn_transaction_details_url *=.*|webhook_bn_transaction_details_url = "https://catalyst.dev.optisom.com/service/v1/user/transaction-details?pwd=${WEBHOOK_PWD}"|' envs/dev.tfvars
                sed -i 's|^webhook_bt_password *=.*|webhook_bt_password = "${WEBHOOK_BT_PASSWORD}"|' envs/dev.tfvars
            '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }


        stage('AWS Configure') {
        steps {
        withCredentials([
            string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            sh '''
            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
            aws configure set default.region ap-south-1
            '''
        }
    }
}


        stage('Terraform Plan') {
            steps {
                sh """
                terraform plan -input=false -var-file="envs/dev.tfvars"
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                terraform apply -auto-approve -input=false -var-file="envs/dev.tfvars"
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
