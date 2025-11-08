pipeline{
    agent {label 'dotnet9'}
    options{
        timeout(time:1 , unit:'HOURS')
    }
    triggers{
        pollSCM('* * * * *')
    }
    stages{
        stage('SCM'){
            steps{
                git url: 'https://github.com/Avani129/nopCommerceNov25.git',
                    branch: 'develop'
            }
        }
        stage('Build'){
            steps{
                sh 'dotnet build -c Release src/Presentation/Nop.Web/Nop.Web.csproj'
                sh 'mkdir published && dotnet publish -o ./published -c Release src/Presentation/Nop.Web/Nop.Web.csproj'
            }
            post {
                success {
                sh '''
                    set -e
                    command -v zip >/dev/null 2>&1 || { sudo apt-get update -y && sudo apt-get install -y zip; }
                    (cd published && zip -r ../published.zip .)
                '''
                archiveArtifacts artifacts: 'published.zip', fingerprint: true
                }
            }
        }
    }
}
