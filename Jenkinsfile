node ('master') {
    checkout scm
    int num = new Random().nextInt() % 4 + 1
    docker_host = "powerci-docker${num}.osuosl.bak"
    println "Connecting to ${docker_host}"
    docker.withServer("tcp://${docker_host}:2375") {
        def testImage = docker.build("test-image")
        testImage.inside {
            sh 'echo inside'
        }
    }
}
