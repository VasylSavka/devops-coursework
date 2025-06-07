pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "devops-node-app:latest"
        CONTAINER_NAME = "devops-app"
        APP_PORT = "3000"
    }

    stages {

        stage('Checkout') {
            steps {
                // Завантаження коду з репозиторію
                git branch: 'main', url: 'https://github.com/VasylSavka/devops-coursework.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                // Підключення AWS credentials з Jenkins Credentials
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('terraform') {
                        // Ініціалізація Terraform і застосування змін до AWS
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                            terraform init -reconfigure
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Build Docker image') {
            steps {
                // Побудова Docker-образу
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Deploy container') {
            steps {
                // Розгортання контейнера
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                    docker run -d --name $CONTAINER_NAME -p $APP_PORT:3000 $DOCKER_IMAGE
                '''
            }
        }

        stage('Healthcheck') {
            steps {
                // Перевірка стану контейнера через healthcheck
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
        success {
            // Повідомлення в Teams при успішному деплої
            echo "✅ Service is up and healthy."
            withCredentials([string(credentialsId: 'teams-webhook', variable: 'TEAMS_WEBHOOK')]) {
                sh '''
                    chmod +x ./send-teams.sh
                    ./send-teams.sh "✅ Deployment succeeded on Jenkins 🔵" "$TEAMS_WEBHOOK"
                '''
            }
        }

        failure {
            // Повідомлення в Teams при помилці
            echo "❌ Build failed or service not healthy."
            withCredentials([string(credentialsId: 'teams-webhook', variable: 'TEAMS_WEBHOOK')]) {
                sh '''
                    chmod +x ./send-teams.sh
                    ./send-teams.sh "❌ Deployment failed on Jenkins 🔴" "$TEAMS_WEBHOOK"
                '''
            }
        }
    }
}
