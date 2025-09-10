pipeline{
    agent any
    environment{
        cred = credentials('aws-key')
        AWS_DEFAULT_REGION = 'us-east-1'   // change if you want us-east-2
    }
    stages{
        stage('checkout stage'){
            steps{
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/ikolele/Super-Project.git']]
                )
            }
        }
        stage('terraform init'){
            steps{
                sh 'terraform init -input=false -no-color'
            }
        }
        stage('terraform plan'){
            steps{
                sh 'terraform plan -input=false -no-color -var="aws_region=${AWS_DEFAULT_REGION}"'
            }
        }
        stage('terraform apply'){
            steps{
                sh 'terraform apply -input=false -no-color -auto-approve -var="aws_region=${AWS_DEFAULT_REGION}"'
            }
        }
    }
}
