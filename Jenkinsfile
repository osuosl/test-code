node {
    checkout scm
    num = new Random().nextInt() % 4 + 1
    docker.withServer("tcp://powerci-docker${num}.osuosl.bak") {
        def testImage = docker.build("test-image")
        testImage.inside {
            sh 'echo inside'
        }
    }
}
