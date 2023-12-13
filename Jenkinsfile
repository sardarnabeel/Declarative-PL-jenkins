//the Jenkins pipeline script you've set up will create an EC2 instance using Terraform first, 
//and then, based on the value of the STOP_INSTANCE parameter, it will either stop or start the EC2 instance.
pipeline {
  agent any

  parameters {
    string(name: 'AWS_REGION', description: 'AWS Region', defaultValue: 'your-aws-region', trim: true)
    string(name: 'AWS_SSO_PROFILE', description: 'AWS SSO Profile', defaultValue: 'your-sso-profile-name', trim: true)
    string(name: 'INSTANCE_NAME', description: 'Instance Name Tag', defaultValue: 'example-instance', trim: true)
    booleanParam(name: 'STOP_INSTANCE', description: 'Stop EC2 Instance', defaultValue: false)
  }

  environment {
        TF_VAR_aws_region    = "${params.AWS_REGION}"
        TF_VAR_instance_name = "${params.INSTANCE_NAME}"
        TF_VAR_stop_instance = "${params.STOP_INSTANCE}"
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

          // AWS SSO Configure
          sh "aws sso configure --profile ${AWS_SSO_PROFILE} --region ${TF_VAR_aws_region}"

          // AWS SSO Login
          def ssoCredentials = sh(script: "aws sso login --profile ${AWS_SSO_PROFILE} --region ${TF_VAR_aws_region}", returnStdout: true).trim()

          // Set AWS CLI environment variables
          def (awsAccessKeyId, awsSecretAccessKey, awsSessionToken) = ssoCredentials.tokenize()

          // Stop or start the instance based on the user's choice
          if (TF_VAR_stop_instance) {
            sh "AWS_ACCESS_KEY_ID=${awsAccessKeyId} AWS_SECRET_ACCESS_KEY=${awsSecretAccessKey} AWS_SESSION_TOKEN=${awsSessionToken} aws ec2 stop-instances --instance-ids ${instanceId} --region ${TF_VAR_aws_region}"
          } else {
            sh "AWS_ACCESS_KEY_ID=${awsAccessKeyId} AWS_SECRET_ACCESS_KEY=${awsSecretAccessKey} AWS_SESSION_TOKEN=${awsSessionToken} aws ec2 start-instances --instance-ids ${instanceId} --region ${TF_VAR_aws_region}"
          }
        }
      }
    }
  }
}







//test file for existing ec2 instnace stop or start
// pipeline {
//     agent any

//     parameters {
//         string(name: 'AWS_REGION', description: 'AWS Region', defaultValue: 'your-aws-region', trim: true)
//         booleanParam(name: 'STOP_INSTANCE', description: 'Stop EC2 Instance', defaultValue: false)
//         booleanParam(name: 'START_INSTANCE', description: 'Start EC2 Instance', defaultValue: false)
//         string(name: 'INSTANCE_ID', description: 'EC2 Instance ID', defaultValue: 'i-xxxxxxxxxxxxxxxxx', trim: true)
//         string(name: 'AWS_PROFILE', description: 'AWS CLI Profile (SSO user)', defaultValue: 'your-aws-profile', trim: true)
//     }

//     environment {
//         AWS_REGION = params.AWS_REGION
//         STOP_INSTANCE = params.STOP_INSTANCE
//         START_INSTANCE = params.START_INSTANCE
//         INSTANCE_ID = params.INSTANCE_ID
//         AWS_PROFILE = params.AWS_PROFILE
//     }

//     stages {
//         stage('Stop or Start EC2 Instance') {
//             steps {
//                 script {
//                     // Create a new AWS CLI configuration file
//                     sh "aws configure --profile ${AWS_PROFILE} set aws_access_key_id ''"
//                     sh "aws configure --profile ${AWS_PROFILE} set aws_secret_access_key ''"
//                     sh "aws configure --profile ${AWS_PROFILE} set aws_session_token ''"

//                     // Authenticate using AWS SSO
//                     sh "aws sso login --profile ${AWS_PROFILE}"

//                     // Check if either STOP_INSTANCE or START_INSTANCE is selected
//                     if (STOP_INSTANCE) {
//                         sh "aws ec2 stop-instances --instance-ids ${INSTANCE_ID} --region ${AWS_REGION} --output json --profile ${AWS_PROFILE}"
//                     } else if (START_INSTANCE) {
//                         sh "aws ec2 start-instances --instance-ids ${INSTANCE_ID} --region ${AWS_REGION} --output json --profile ${AWS_PROFILE}"
//                     } else {
//                         echo "No action specified. Please choose either stop or start."
//                         currentBuild.result = 'FAILURE'
//                         error("No action specified.")
//                     }
//                 }
//             }
//         }
//     }
// }
