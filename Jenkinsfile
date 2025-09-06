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
        sshagent (credentials: [env.SSH_CRED]) {
          sh '''
            scp scripts/puppet_install.sh $SLAVE:/tmp/puppet_install.sh
            ssh $SLAVE "sudo bash /tmp/puppet_install.sh"
          '''
        }
      }
    }

    stage('Job2: Install Docker via Ansible') {
      steps {
        sh 'ansible-playbook -i 65.0.93.189, ansible/install_docker.yml --ssh-common-args="-o StrictHostKeyChecking=no" -u ubuntu'
      }
    }

    stage('Job3: Build & Deploy App') {
      steps {
        sshagent (credentials: [env.SSH_CRED]) {
          sh '''
            scp Dockerfile index.php $SLAVE:/tmp/
            ssh $SLAVE "
              cd /tmp &&
              docker build -t projcert_app . &&
              docker run -d --name projcert_app -p 8080:80 projcert_app
            "
          '''
        }
      }
    }
  }

  post {
    failure {
      sshagent (credentials: [env.SSH_CRED]) {
        sh '''
          scp scripts/cleanup_container.sh $SLAVE:/tmp/cleanup.sh
          ssh $SLAVE "bash /tmp/cleanup.sh"
        '''
      }
    }
  }
}
