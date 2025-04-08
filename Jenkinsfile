pipeline {
    agent {
        label 'agent-1-lablel'
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
                    def pakageJson = readJSON file: 'scripts/package.json'
                    appversion = packageJson.version
                    echo "app Version: ${appversion}"
                }
            }
        }
    }
    
}