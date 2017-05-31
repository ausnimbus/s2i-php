/**
* NOTE: THIS JENKINSFILE IS GENERATED VIA "./hack/run update"
*
* DO NOT EDIT IT DIRECTLY.
*/
node {
        def versions = "5.6,7.0,7.1".split(',');
        for (int i = 0; i < versions.length; i++) {
                try {
                        stage("Build (PHP ${versions[i]})") {
                                openshift.withCluster() {
        openshift.apply([
                                "apiVersion" : "v1",
                                "items" : [
                                        [
                                                "apiVersion" : "v1",
                                                "kind" : "ImageStream",
                                                "metadata" : [
                                                        "name" : "php",
                                                        "labels" : [
                                                                "builder" : "s2i-php"
                                                        ]
                                                ],
                                                "spec" : [
                                                        "tags" : [
                                                                [
                                                                        "name" : "${versions[i]}-alpine",
                                                                        "from" : [
                                                                                "kind" : "DockerImage",
                                                                                "name" : "php:${versions[i]}-fpm-alpine",
                                                                        ],
                                                                        "referencePolicy" : [
                                                                                "type" : "Source"
                                                                        ]
                                                                ]
                                                        ]
                                                ]
                                        ],
                                        [
                                                "apiVersion" : "v1",
                                                "kind" : "ImageStream",
                                                "metadata" : [
                                                        "name" : "s2i-php",
                                                        "labels" : [
                                                                "builder" : "s2i-php"
                                                        ]
                                                ]
                                        ]
                                ],
                                "kind" : "List"
                        ])
        openshift.apply([
                                "apiVersion" : "v1",
                                "kind" : "BuildConfig",
                                "metadata" : [
                                        "name" : "s2i-php-${versions[i]}",
                                        "labels" : [
                                                "builder" : "s2i-php"
                                        ]
                                ],
                                "spec" : [
                                        "output" : [
                                                "to" : [
                                                        "kind" : "ImageStreamTag",
                                                        "name" : "s2i-php:${versions[i]}"
                                                ]
                                        ],
                                        "runPolicy" : "Serial",
                                        "resources" : [
                                            "limits" : [
                                                "memory" : "2Gi"
                                            ]
                                        ],
                                        "source" : [
                                                "git" : [
                                                        "uri" : "https://github.com/ausnimbus/s2i-php"
                                                ],
                                                "type" : "Git"
                                        ],
                                        "strategy" : [
                                                "dockerStrategy" : [
                                                        "dockerfilePath" : "versions/${versions[i]}/Dockerfile",
                                                        "from" : [
                                                                "kind" : "ImageStreamTag",
                                                                "name" : "php:${versions[i]}-alpine"
                                                        ]
                                                ],
                                                "type" : "Docker"
                                        ]
                                ]
                        ])
        echo "Created s2i-php:${versions[i]} objects"
        /**
        * TODO: Replace the sleep with import-image
        * openshift.importImage("php:${versions[i]}-alpine")
        */
        sleep 60

        echo "==============================="
        echo "Starting build s2i-php-${versions[i]}"
        echo "==============================="
        def builds = openshift.startBuild("s2i-php-${versions[i]}");

        timeout(10) {
                builds.untilEach(1) {
                        return it.object().status.phase == "Complete"
                }
        }
        echo "Finished build ${builds.names()}"
}

                        }
                        stage("Test (PHP ${versions[i]})") {
                                openshift.withCluster() {
        echo "==============================="
        echo "Starting test application"
        echo "==============================="

        def testApp = openshift.newApp("https://github.com/ausnimbus/php-ex", "--image-stream=s2i-php:${versions[i]}", "-l app=php-ex");
        echo "new-app created ${testApp.count()} objects named: ${testApp.names()}"
        testApp.describe()

        def testAppBC = testApp.narrow("bc");
        def testAppBuilds = testAppBC.related("builds");
        echo "Waiting for ${testAppBuilds.names()} to finish"
        timeout(10) {
                testAppBuilds.untilEach(1) {
                        return it.object().status.phase == "Complete"
                }
        }
        echo "Finished ${testAppBuilds.names()}"

        def testAppDC = testApp.narrow("dc");
        echo "Waiting for ${testAppDC.names()} to start"
        timeout(10) {
                testAppDC.untilEach(1) {
                        return it.object().status.availableReplicas >= 1
                }
        }
        echo "${testAppDC.names()} is ready"

        def testAppService = testApp.narrow("svc");
        def testAppHost = testAppService.object().spec.clusterIP;
        def testAppPort = testAppService.object().spec.ports[0].port;

        sleep 60
        echo "Testing endpoint ${testAppHost}:${testAppPort}"
        sh "curl -o /dev/null $testAppHost:$testAppPort"
}

                        }
                        stage("Stage (PHP ${versions[i]})") {
                                openshift.withCluster() {
        echo "==============================="
        echo "Tag new image into staging"
        echo "==============================="

        openshift.tag("ausnimbus-ci/s2i-php:${versions[i]}", "ausnimbus/s2i-php:${versions[i]}")
}

                        }
                } finally {
                        openshift.withCluster() {
                                echo "Deleting test resources php-ex"
                                openshift.selector("dc", [app: "php-ex"]).delete()
                                openshift.selector("bc", [app: "php-ex"]).delete()
                                openshift.selector("svc", [app: "php-ex"]).delete()
                                openshift.selector("is", [app: "php-ex"]).delete()
                                openshift.selector("pods", [app: "php-ex"]).delete()
                                openshift.selector("routes", [app: "php-ex"]).delete()
                        }
                }

        }
}
