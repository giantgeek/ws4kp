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
        // Skip everything (including deploys) when a build was started automatically and the
        // commit has already built successfully, e.g. by a timer, branch indexing or a re-poll.
        // Compares against the last *successful* build, so a failed commit keeps rebuilding
        // (and failing) instead of being masked by skipped "SUCCESS" runs.
        // Manual "Build Now" / "Build with Parameters" always runs.
        stage('Pipeline') {
            when {
                anyOf {
                    triggeredBy 'UserIdCause'
                    // Also true for the first build, when there is no previous successful commit
                    expression { env.GIT_COMMIT != env.GIT_PREVIOUS_SUCCESSFUL_COMMIT }
                }
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
    }
}
