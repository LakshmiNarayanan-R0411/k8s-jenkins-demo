def run(String cmd) { if (isUnix()) { sh cmd } else { bat cmd } }

def dockerLogin() {
  withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                   usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
    if (isUnix()) { sh 'echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin' }
    else          { bat 'echo %DH_PASS%| docker login -u %DH_USER% --password-stdin' }
  }
}

pipeline {
  agent any

  environment {
    IMAGE      = 'lakshminarayananr0411/k8s-demo'
    KUBECONFIG = credentials('kubeconfig')
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Image') {
      steps { run "docker build --build-arg BUILD_NUMBER=${env.BUILD_NUMBER} -t ${env.IMAGE}:${env.BUILD_NUMBER} -t ${env.IMAGE}:latest ." }
    }

    stage('Push Image') {
      steps {
        script {
          dockerLogin()
          run "docker push ${env.IMAGE}:${env.BUILD_NUMBER}"
          run "docker push ${env.IMAGE}:latest"
        }
      }
    }

    stage('Kubernetes Step') {
      steps {
        // >>>>>> TOMORROW: CHANGE ONLY THESE LINES (see README.md) <<<<<<
        run 'kubectl apply -f k8s/deployment.yaml'
        run 'kubectl apply -f k8s/service.yaml'
        run 'kubectl rollout status deployment/web-app --timeout=120s'
        // >>>>>> END <<<<<<
      }
    }

    stage('Verify') {
      steps { run 'kubectl get pods,svc' }
    }
  }
}
