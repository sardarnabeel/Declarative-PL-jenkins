//the Jenkins pipeline script you've set up will create an EC2 instance using Terraform first, 
//and then, based on the value of the STOP_INSTANCE parameter, it will either stop or start the EC2 instance.
pipeline {
  agent any

  parameters {
    string(name: 'AWS_REGION', description: 'AWS Region', defaultValue: 'your-aws-region', trim: true)
    string(name: 'AWS_PROFILE', description: 'AWS CLI Profile (SSO user)', defaultValue: 'your-aws-profile', trim: true)
    string(name: 'INSTANCE_NAME', description: 'Instance Name Tag', defaultValue: 'example-instance', trim: true)
    booleanParam(name: 'STOP_INSTANCE', description: 'Stop EC2 Instance', defaultValue: false)
    booleanParam(name: 'START_INSTANCE', description: 'Start EC2 Instance', defaultValue: false)
  }

  environment {
    TF_VAR_aws_region    = "${params.AWS_REGION}"
    TF_VAR_instance_name = "${params.INSTANCE_NAME}"
    AWS_PROFILE = "${params.AWS_PROFILE}"
  }
  
  stages {
    stage('Terraform Apply') {
      steps {
        script {
          // Initialize and apply Terraform
          sh 'terraform init'
          sh 'terraform apply -auto-approve'

          // Capture the instance ID from Terraform output
          def instanceId = sh(script: 'terraform output instance_id', returnStdout: true).trim()
          // Now you can use 'instanceId' for further actions
          echo "Captured Instance ID: ${instanceId}"

          // Authenticate using AWS SSO
          sh "aws sso login --profile ${AWS_PROFILE}"

                    // Check if either STOP_INSTANCE or START_INSTANCE is selected
                    if (params.STOP_INSTANCE) {
                        sh "aws ec2 stop-instances --instance-ids ${instanceId} --region ${TF_VAR_aws_region} --output json --profile ${AWS_PROFILE}"
                    } else if (params.START_INSTANCE) {
                        //sh "aws ec2 start-instances --instance-ids ${instanceId} --region ${AWS_REGION} --output json --profile ${AWS_PROFILE}"
                        sh "aws ec2 start-instances --instance-ids ${instanceId} --region ${TF_VAR_aws_region} --output json --profile ${AWS_PROFILE}"
                    } else {
                        echo "No action specified. Please choose either stop or start."
                        currentBuild.result = 'FAILURE'
                        error("No action specified.")
          }
        }
      }
    }
  }
}






