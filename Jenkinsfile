pipeline {
    agent any

    options {
        ansiColor('xterm')
        timestamps()
    }

    environment {
        // Change region here if you want us-east-2 instead
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('checkout stage') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/ikolele/Super-Project.git'
                    ]]
                )
            }
        }

        // Optional but very useful: confirm AWS identity, region, AMI and key exist
        stage('pre-apply debug') {
            steps {
                sh '''
                  set -euxo pipefail
                  echo "Region: ${AWS_DEFAULT_REGION}"
                  which terraform && terraform version
                  which aws && aws --version
                  aws sts get-caller-identity

                  # If your TF uses a fixed AMI id, sanity-check it exists in this region.
                  # Update the AMI below to whatever your TF config uses (if any).
                  aws ec2 describe-images \
                    --image-ids ami-00ca32bbc84273381 \
                    --region "${AWS_DEFAULT_REGION}" \
                    --query 'Images[].ImageId' || true

                  # If your TF uses a key_name, sanity-check it exists (edit the name).
                  aws ec2 describe-key-pairs \
                    --key-names kg-1 \
                    --region "${AWS_DEFAULT_REGION}" \
                    --query 'KeyPairs[].KeyName' || true
                '''
            }
        }

        stage('terraform init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                    sh '''
                      set -euxo pipefail
                      terraform init -input=false -no-color
                    '''
                }
            }
        }

        stage('terraform plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                    sh '''
                      set -euxo pipefail
                      terraform plan -input=false -no-color -var="aws_region=${AWS_DEFAULT_REGION}" -out=plan.tfplan
                      terraform show -no-color plan.tfplan | sed -n '1,150p' || true
                    '''
                }
            }
        }

        stage('terraform apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                    sh '''
                      set -euxo pipefail
                      terraform apply -input=false -no-color -auto-approve plan.tfplan
                    '''
                }
            }
        }
    }
}
