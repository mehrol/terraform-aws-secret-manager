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
                script {
                    // Path to your tfvars file
                    def tfvarsFile = "envs/dev.tfvars"

                    // Overwrite values dynamically from Jenkins credentials or environment
                    sh """
                        cat > ${tfvarsFile} <<EOF
                        region   = "ap-south-1"
                        stage    = "dev"

                        # Database configuration for the QA environment
                        db_host     = "admin"
                        db_username = "${DB_USERNAME}"
                        db_password = "${DB_PASSWORD}"
                        db_name     = "bn_payment_posting_dev"

                        # Stripe configuration for the QA environment
                        stripe_secret_diagnostics = "${STRIPE_SECRET_DIAGNOSTICS}"
                        stripe_secret_holdings    = "${STRIPE_SECRET_HOLDINGS}"
                        stripe_secret_webhook     = "${STRIPE_SECRET_WEBHOOK}"

                        # Webhook configuration for the QA environment
                        webhook_bn_transaction_details_url  = "https://catalyst.dev.optisom.com/service/v1/user/transaction-details?pwd=${WEBHOOK_PWD}"
                        webhook_bt_retries                  = 3
                        webhook_bt_delay_ms                 = 2000
                        webhook_bt_username                 = "abhargava@sleepdataapitest"
                        webhook_bt_password                 = "${WEBHOOK_BT_PASSWORD}"
                        webhook_bt_soap_action_deposit      = "http://www.brightree.com/external/InvoicePaymentsService/IInvoicePaymentsService/DepositCreate"
                        webhook_bt_soap_action_deposit_receipt = "http://www.brightree.com/external/InvoicePaymentsService/IInvoicePaymentsService/ReceiptCreate"
                        webhook_bt_soap_action_unapplied_payment = "http://www.brightree.com/external/InvoicePaymentsService/IInvoicePaymentsService/UnappliedPaymentCreate"
                        webhook_bt_unapplied_payment_diagnostics_branch_bt_id = 105
                        webhook_bt_unapplied_payment_holdings_branch_bt_id   = 110
                        webhook_bt_unapplied_payment_pay_or_key              = 102
                        EOF
                    """
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
            string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            sh """
            aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%
            aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%
            aws configure set default.region ${params.AWS_REGION}
            """
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
