// Jenkins pipeline for ws4kp (Node.js, gulp build).
// Needs the NodeJS plugin and a NodeJS installation named 'node-24' (Node 24.x)
// under Manage Jenkins -> Tools.
pipeline {
    agent any

    tools {
        nodejs 'node-24'
    }

    options {
        timestamps()
        timeout(time: 20, unit: 'MINUTES')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '5'))
    }

    triggers {
        // GitHub webhooks cannot reach the NAS, so poll for new commits every ~5 minutes
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Info') {
            steps {
                sh 'node --version'
                sh 'npm --version'
            }
        }

        stage('Install') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Build') {
            steps {
                // Same as `make build`: gulp buildDist -> dist/
                sh 'npm run build'
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'dist/**', fingerprint: true
            }
        }
    }
}
