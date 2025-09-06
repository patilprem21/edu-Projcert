pipeline {
  agent any
  environment {
    GIT_REPO = 'https://github.com/patilprem21/edu-Projcert.git'
    SLAVE_IP = '65.0.93.189'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: env.GIT_REPO
      }
    }

    stage('Job1: Install Puppet Agent') {
      steps {
        sh '''
          scp -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no scripts/puppet_install.sh ubuntu@$SLAVE_IP:/tmp/puppet_install.sh
          ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@$SLAVE_IP "sudo bash /tmp/puppet_install.sh"
        '''
      }
    }

    stage('Job2: Install Docker via Ansible') {
      steps {
        sh 'ansible-playbook -i 65.0.93.189, ansible/install_docker.yml --ssh-common-args="-o StrictHostKeyChecking=no" -u ubuntu'
      }
    }

    stage('Job3: Build & Deploy App') {
      steps {
        sh '''
          scp -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no Dockerfile index.php ubuntu@$SLAVE_IP:/tmp/
          ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@$SLAVE_IP "
            cd /tmp &&
            docker build -t projcert_app . &&
            docker run -d --name projcert_app -p 8080:80 projcert_app
          "
        '''
      }
    }
  }

  post {
    failure {
      sh '''
        ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ubuntu@$SLAVE_IP "
          docker stop projcert_app || true
          docker rm projcert_app || true
          docker image prune -f
        "
      '''
    }
  }
}
