@test "jenkins is available on port 8080" {
	wget -O - http://localhost:8080 2>&1 | grep 'Dashboard \[Jenkins\]'
}

@test "kitchen is executable" {
	export PATH=/var/lib/gems/1.9.1/bin:$PATH
	which kitchen
}

@test "foodcritic is executable" {
	export PATH=/var/lib/gems/1.9.1/bin:$PATH
	which foodcritic
}

@test "git is executable" {
	which git
}

@test "the jenkins user has the vagrant-berkshelf plugin installed" {
	grep vagrant-berkshelf ~jenkins/.vagrant.d/plugins.json
}
