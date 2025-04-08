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