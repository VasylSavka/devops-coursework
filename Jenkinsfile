pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "devops-node-app:latest"
        CONTAINER_NAME = "devops-app"
        APP_PORT = "3000"
        TEAMS_WEBHOOK = credentials('teams-webhook')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/VasylSavka/devops-coursework.git'
            }
        }

        stage('Build Docker image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Deploy container') {
            steps {
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                    docker run -d --name $CONTAINER_NAME -p $APP_PORT:3000 $DOCKER_IMAGE
                '''
            }
        }

        stage('Healthcheck') {
            steps {
                script {
                    timeout(time: 30, unit: 'SECONDS') {
                        waitUntil {
                            def health = sh(script: "docker inspect --format='{{.State.Health.Status}}' $CONTAINER_NAME", returnStdout: true).trim()
                            echo "Container health: ${health}"
                            return (health == "healthy")
                        }
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "❌ Build failed or service not healthy."
            sh "./send-teams.sh '❌ Deployment failed on Jenkins' '${TEAMS_WEBHOOK}'"
        }
        success {
            echo "✅ Service is up and healthy."
            sh "./send-teams.sh '✅ Deployment succeeded on Jenkins' '${TEAMS_WEBHOOK}'"
        }
    }
}
