pipeline {
    agent any
    
    tools {
        maven "M3"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/EDRV02/lbg-hello-world-maven.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn clean compile"
            }
        }

        stage('Package') {
            steps {
                sh "mvn -Dmaven.test.skip -Dmaven.compile.skip package"
            }
        }
        stage ('SonarQube Analysis') {
            environment {
                 scannerHome = tool 'sonarqube'
            }
            steps {
                 withSonarQubeEnv('sonar-qube-1') {
                 sh "${scannerHome}/bin/sonar-scanner -Dsonar.java.binaries=target/classes"
            }
                 timeout(time: 10, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                 }
            }
        }
        stage('Test') {
            steps {
                 sh "mvn -Dmaven.compile.skip test"
            }
        }
        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar',
                allowEmptyArchive: false
            }
        }

    }
    environment {
    registry = "eduardo1492/hello-maven-job"
        registryCredentials = "dockerhub_id"
        dockerImage = ""
    }
    agent any
        stages {
            stage ('Build Docker Image'){
                steps{
                    script {
                        dockerImage = docker.build(registry)
                    }
                }
            }

            stage ("Push to Docker Hub"){
                steps {
                    script {
                        docker.withRegistry('', registryCredentials) {
                            dockerImage.push("${env.BUILD_NUMBER}")
                            dockerImage.push("latest")
                        }
                    }
                }
            }

            stage ("Clean up"){
                steps {
                    script {
                        sh 'docker image prune --all --force --filter "until=48h"'
                           }
                }
            }
        }
}