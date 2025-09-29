region   = "ap-south-1"
stage       = "qa"

# Database configuration for the QA environment
db_host   = "admin"
db_username = "SECRET"
db_password = "SECRET"
db_name   = "bn_payment_posting_dev"

# Stripe configuration for the QA environment
stripe_secret_diagnostics = "SECRET"
stripe_secret_holdings    = "SECRET"
stripe_secret_webhook     = "SECRET"

# Webhook configuration for the QA environment
webhook_bn_transaction_details_url  = "https://catalyst.dev.optisom.com/service/v1/user/transaction-details?pwd=SECRET"
webhook_bt_retries                  = 3
webhook_bt_delay_ms                 = 2000
webhook_bt_username                 = "abhargava@sleepdataapitest"
webhook_bt_password                 = "SECRET"
webhook_bt_soap_action_deposit      = "http://www.brightree.com/external/InvoicePaymentsService/IInvoicePaymentsService/DepositCreate"
webhook_bt_soap_action_deposit_receipt = "http://www.brightree.com/external/InvoicePaymentsService/IInvoicePaymentsService/ReceiptCreate"
webhook_bt_soap_action_unapplied_payment = "http://www.brightree.com/external/InvoicePaymentsService/IInvoicePaymentsService/UnappliedPaymentCreate"
webhook_bt_unapplied_payment_diagnostics_branch_bt_id = 105
webhook_bt_unapplied_payment_holdings_branch_bt_id   = 110
webhook_bt_unapplied_payment_pay_or_key              = 102