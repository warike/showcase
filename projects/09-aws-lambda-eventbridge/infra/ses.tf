locals {
  domain = var.domain
  email  = var.sandbox_email
}

## SES domain identiy
data "aws_ses_domain_identity" "warike_development_primary" {
  domain = local.domain
}

## SES email identity
data "aws_ses_email_identity" "warike_development_sandbox_email" {
  email = local.email
}

## SES template
resource "aws_ses_template" "warike_development_report_template" {
  name    = "report_template"
  subject = "Report - Venturia"
  html    = <<EOF
    <html>
      <head>
          <style>
          body { font-family: Arial, sans-serif; line-height: 1.5; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          </style>
      </head>
      <body>
          <div class="container">
              <div class="report-text">
                  {{report_text}}
              </div>
          </div>
      </body>
    </html>
    EOF

  text = <<EOF
    {{report_text}}
    EOF
}