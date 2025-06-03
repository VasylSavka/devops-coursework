pipeline {
  agent any

  environment {
    IMAGE_NAME = "devops-node-app"
    CONTAINER_NAME = "devops-app"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/VasylSavka/devops-coursework.git', branch: 'main'
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'npm install --production'
      }
    }

    stage('Build Docker image') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:latest ."
      }
    }

    stage('Deploy container') {
      steps {
        sh """
          docker stop ${CONTAINER_NAME} || true
          docker rm ${CONTAINER_NAME} || true
          docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${IMAGE_NAME}:latest
        """
      }
    }

    stage('Healthcheck') {
      steps {
        sh 'curl --fail http://localhost:3000/health || exit 1'
      }
    }
  }

  post {
    success {
      echo '✅ Build and deployment successful!'
    }
    failure {
      echo '❌ Build failed or service not healthy.'
    }
  }
}
