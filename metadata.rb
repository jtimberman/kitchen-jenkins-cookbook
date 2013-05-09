name             "kitchen-jenkins"
maintainer       "Joshua Timberman"
maintainer_email "cookbooks@housepub.org"
license          "Apache 2.0"
description      "Set up a node to run test-kitchen in Jenkins"
version          "0.1.0"

depends "virtualbox", ">= 1.0.0"
depends "vagrant", ">= 0.2.0"
depends "virtualbox"
depends "jenkins"

supports "debian"
supports "ubuntu"
