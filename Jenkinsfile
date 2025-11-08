pipeline {
  agent { label 'dotnet9' }
  options {
    timeout(time: 1, unit: 'HOURS')
    skipDefaultCheckout(true)   // keep your explicit SCM stage only
  }
  triggers { pollSCM('* * * * *') }

  stages {
    stage('SCM') {
      steps {
        git url: 'https://github.com/Avani129/nopCommerceNov25.git', branch: 'develop'
      }
    }

    stage('Build & Package') {
      steps {
        sh '''
          set -eu

          # Clean previous outputs (safe if missing)
          rm -rf ./published
          rm -f  ./published.zip

          # Restore + Build
          dotnet restore src/Presentation/Nop.Web/Nop.Web.csproj
          dotnet build -c Release --no-restore src/Presentation/Nop.Web/Nop.Web.csproj

          # Publish binaries (no rebuild)
          mkdir -p published
          dotnet publish -c Release --no-build -o ./published src/Presentation/Nop.Web/Nop.Web.csproj

          # Ensure 'zip' exists (best-effort install on Debian/Ubuntu)
          if ! command -v zip >/dev/null 2>&1; then
            if command -v apt-get >/dev/null 2>&1; then
              sudo apt-get update -y && sudo apt-get install -y zip || true
            fi
          fi

          # Create artifact
          (cd published && zip -r ../published.zip .)

          # Sanity check to fail early if something went wrong
          test -s published.zip
        '''
      }
    }
  }

  post {
    success {
      archiveArtifacts artifacts: 'published.zip', fingerprint: true
    }
    cleanup {
      // Remove workspace copies after archiving
      sh '''
        rm -rf ./published || true
        rm -f  ./published.zip || true
      '''
    }
  }
}
