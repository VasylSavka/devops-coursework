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
                git branch: 'main', url: 'https://github.com/VasylSavka/devops-coursework.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'teams-webhook-terraform', variable: 'TERRAFORM_WEBHOOK'),
                ]) {
                    dir('terraform') {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                            terraform init -reconfigure
                            terraform state rm null_resource.teams_notify_destroy || true
                            terraform apply -auto-approve -var="teams_webhook_url=$TERRAFORM_WEBHOOK"
                        '''
                    }
                }
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
        success {
            echo "✅ Service is up and healthy."
            withCredentials([string(credentialsId: 'teams-webhook', variable: 'TEAMS_WEBHOOK')]) {
                sh '''
                    chmod +x ./send-teams.sh
                    ./send-teams.sh "✅ Deployment succeeded on Jenkins 🔵" "$TEAMS_WEBHOOK"
                '''
            }
        }

        failure {
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
