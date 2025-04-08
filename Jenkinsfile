pipeline {
    agent {
        label 'agent-1-label'
    }
    options{
        timeout(time: 50, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    environment {
        DEBUG = 'true'
        appversion = ''
        region = 'us-east-1'
        acc_ID = '135808959960'
        project = 'expense'
        environment = 'prod'
        component = 'backend'

    }
    
    stages {
        stage('Read the application version') {
            steps {
                script{
                    def packageJson = readJSON file: 'scripts/package.json'
                    appversion = packageJson.version
                    echo "app Version: ${appversion}"
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh """
                    cd scripts
                    npm install
                """
            }
        }

        stage("Docker Build Image") {
            steps {
                sh """
                    docker build -t naveenrajoli/backend:${appversion} .
                    docker images
                """
            }
        }

        stage('Push docker image to ECR') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-cred') {
                    sh """                   
                        aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${acc_ID}.dkr.ecr.${region}.amazonaws.com

                        docker build -t ${acc_ID}.dkr.ecr.${region}.amazonaws.com/kdp-${project}-${environment}/${component}:${appversion} .

                        docker images

                        docker push ${acc_ID}.dkr.ecr.${region}.amazonaws.com/kdp-${project}-${environment}/${component}:${appversion}                 

                    """
                }
            }
        }

        stage('Deploy Backend') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-cred') {
                    sh """
                        export PATH=\$PATH:/usr/local/bin/kubectl
                        aws eks update-kubeconfig --region us-east-1 --name kdp-expense-prod-eks
                        export KUBECONFIG=/home/ec2-user/.kube/config
                        kubectl config get-contexts
                        kubectl get nodes
                        
                    """
                }

            }
        }
        

    }
    








    post {
        always{
            echo 'this will run always'
            deleteDir()
        }
        success{
            echo 'this will run on success'
        }
        failure{
            echo 'this will run at failure'
        }
    }
}