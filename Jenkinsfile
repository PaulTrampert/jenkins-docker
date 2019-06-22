pipeline {
  agent any

  environment {
    DOCKER_REPO = "docker.ptrampert.com"
    DOCKER_REPO_CREDENTIALS = "nexus"
    IMAGE_NAME = "jenkins"
    BRANCH_TAG = (BRANCH_NAME == "master") ? "latest" : BRANCH_NAME
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timestamps()
  }

  stages {
    stage("Build Image") {
      script {
        docker.build("$DOCKER_REPO/$IMAGE_NAME:$BRANCH_TAG")
      }
    }

    stage("Push Image") {
      withDockerRegistry(credentialsId: 'nexus', url: "https://$DOCKER_REPO") {
        script {
          image("$DOCKER_REPO/$IMAGE_NAME:$BRANCH_TAG").push()
        }
      }
    }
  }
}