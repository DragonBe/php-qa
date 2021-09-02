pipeline {

    agent {
        label 'docker-master'
    }

    parameters {
        choice(
            name: 'PHP_VER',
            choices: ['7.3', '7.4', '8.0', '8.1'],
            description: 'Select PHP version to build'
        )
    }

    triggers {
        parameterizedCron('''
            # leave spaces where you want them around the parameters. They'll be trimmed.
            # we let the build run with the default name
            H H * * H %PHP_VER=7.3
            H H * * H %PHP_VER=7.4
            H H * * H %PHP_VER=8.0
            H H * * H %PHP_VER=8.1
        ''')
    }

    stages {

        stage('Checkout from SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    extensions: [],
                    userRemoteConfigs: [[
                        credentialsId: 'f84111b1-0ee6-4476-afff-6c87e18f1e20',
                        url: 'git@github.com:DragonBe/php-qa.git'
                    ]]
                ])
            }
        }

        stage('Build container') {
            steps {
                sh "/usr/local/bin/docker build --pull --no-cache --quiet --file Dockerfile-${params.PHP_VER} --tag dragonbe/php-qa:${params.PHP_VER} ."
            }
        }

        stage('Test container') {
            steps {
                sh "test 1 -eq \$(/usr/local/bin/docker run dragonbe/php-qa:${params.PHP_VER} bash -c 'php --version | grep -c \"^PHP ${params.PHP_VER}\"')"
            }
        }

        stage('Push container to Docker HUB') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerID', passwordVariable: 'DockerPass', usernameVariable: 'DockerUser')]) {
                    sh "/bin/bash -c 'echo $DockerPass | /usr/local/bin/docker login --username $DockerUser --password-stdin https://index.docker.io/v1/'"
                }
                withCredentials([string(credentialsId: 'SnykToken', variable: 'SnykToken')]) {
                    echo 'To setup later'
                }
                sh "/usr/local/bin/docker push --quiet dragonbe/php-qa:${params.PHP_VER}"
            }
        }

        stage('Tag container for JFrog') {
            steps {
                sh "/usr/local/bin/docker tag dragonbe/php-qa:${params.PHP_VER} in2it.jfrog.io/docker-php/php-qa:${params.PHP_VER}"
            }
        }

        stage('Push container to JFrog') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'JfrogID', passwordVariable: 'DockerPass', usernameVariable: 'DockerUser')]) {
                    sh "/bin/bash -c 'echo $DockerPass | /usr/local/bin/docker login --username $DockerUser --password-stdin https://in2it.jfrog.io'"
                }
                sh "/usr/local/bin/docker push --quiet in2it.jfrog.io/docker-php/php-qa:${params.PHP_VER}"
            }
        }
    }
}
