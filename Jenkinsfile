pipeline {
  agent { node { label 'salt' } }
  stages {
      stage('Linting') {
          steps {
          echo 'linting..'
          sh("./linter.sh")
          }
      }
      stage('Build Production') {
        when { 
          branch 'master'
          anyOf {
            changeset "**"
          }
        }
        steps {
            echo 'Run Highstate'
            sh("sudo ./deploy.sh")
          }  
        }
      stage('Build Docs') {
        when { changeset "docs/**" }
        steps {
            echo 'Build Docs...'
          }  
        }
      }
      post {
        success {
           echo "Build successfully..."
           slackSend color: "good", message: "Build successfully on $JOB_NAME..."
       }
       failure {
           echo "Build failed..."
           slackSend color: "danger", message: "Build failed on $JOB_NAME..."
       }
    }
}
