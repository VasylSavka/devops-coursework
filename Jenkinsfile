properties([
  parameters([
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose Terraform action')
  ])
])

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

    stage('Terraform Init & Action') {
      steps {
        withCredentials([
          string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'teams-webhook-terraform', variable: 'TERRAFORM_WEBHOOK')
        ]) {
          dir('terraform') {
            sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

              terraform init -reconfigure

              if [ "$ACTION" = "destroy" ]; then
                terraform destroy -auto-approve -var="teams_webhook_url=$TERRAFORM_WEBHOOK"
              else
                terraform apply -auto-approve -var="teams_webhook_url=$TERRAFORM_WEBHOOK"
              fi
            '''
          }
        }
      }
    }

    stage('Build Docker image') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        sh 'docker build -t $DOCKER_IMAGE .'
      }
    }

    stage('Deploy container') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        sh '''
          docker stop $CONTAINER_NAME || true
          docker rm $CONTAINER_NAME || true
          docker run -d --name $CONTAINER_NAME -p $APP_PORT:3000 $DOCKER_IMAGE
        '''
      }
    }

    stage('Healthcheck') {
      when {
        expression { params.ACTION == 'apply' }
      }
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
      script {
        def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
        def user = currentBuild.getBuildCauses()[0]?.userName ?: "N/A"
        def job = env.JOB_NAME
        def buildNum = env.BUILD_NUMBER
        def gitCommit = sh(script: 'git log -1 --pretty=format:%h', returnStdout: true).trim()
        def gitMessage = sh(script: 'git log -1 --pretty=%s', returnStdout: true).trim()
        def branch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()

        def message = (params.ACTION == 'apply') ?
            """✅ Deployment succeeded on Jenkins 🔵
🕒 Time: ${timestamp}
👤 User: ${user}
🏷️ Job: ${job}
🔢 Build: #${buildNum}
💬 Commit: ${gitCommit} - ${gitMessage}
🌿 Branch: ${branch}""" :
            """🗑️ Terraform destroy executed from Jenkins ⚠️
🕒 Time: ${timestamp}
👤 User: ${user}
🏷️ Job: ${job}
🔢 Build: #${buildNum}
💬 Commit: ${gitCommit} - ${gitMessage}
🌿 Branch: ${branch}"""

        withCredentials([string(credentialsId: 'teams-webhook', variable: 'TEAMS_WEBHOOK')]) {
          sh """
            chmod +x ./send-teams.sh
            ./send-teams.sh "${message}" "$TEAMS_WEBHOOK"
          """
        }
      }
    }

    failure {
      script {
        def timestamp = new Date().format("yyyy-MM-dd HH:mm:ss")
        def user = currentBuild.getBuildCauses()[0]?.userName ?: "N/A"
        def job = env.JOB_NAME
        def buildNum = env.BUILD_NUMBER
        def gitCommit = sh(script: 'git log -1 --pretty=format:%h', returnStdout: true).trim()
        def gitMessage = sh(script: 'git log -1 --pretty=%s', returnStdout: true).trim()
        def branch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()

        def message = """❌ Deployment failed on Jenkins 🔴
🕒 Time: ${timestamp}
👤 User: ${user}
🏷️ Job: ${job}
🔢 Build: #${buildNum}
💬 Commit: ${gitCommit} - ${gitMessage}
🌿 Branch: ${branch}"""

        withCredentials([string(credentialsId: 'teams-webhook', variable: 'TEAMS_WEBHOOK')]) {
          sh """
            chmod +x ./send-teams.sh
            ./send-teams.sh "${message}" "$TEAMS_WEBHOOK"
          """
        }
      }
    }
  }
}
