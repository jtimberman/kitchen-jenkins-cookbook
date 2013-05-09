Overview
========

This cookbook will set up a node to be able to run Jenkins build jobs
for test-kitchen.

Requirements
============

Tested on Chef 11. See TESTING.md.

## Platform

* Debian (6.0.7, 7.0)
* Ubuntu (12.04)

## Cookbooks

* vagrant
* virtualbox
* jenkins (at this time requires using the cookbook from the master
  branch as the new release isn't complete yet)

Attributes
==========

This cookbook sets the following vagrant node attributes (used by the
vagrant cookbook). These are `default` level, so you can override them
with another priority level (such as a role, or environment) if you
prefer a different version of Vagrant. This just happened to be the
current values when I tested this cookbook originally.

* `node['vagrant']['url']` - URL to download the vagrant package.
* `node['vagrant']['checksum']` - SHA256 checksum of the vagrant package.

As test-kitchen is still in alpha as of this writing, we specify a
particular version of the pre-release to install that has been tested.

* `node['kitchen']['gem_version']` - The version of the test-kitchen
  gem to install.

Recipes
=======

## default

As vagrant+virtualbox is the default driver for test-kitchen 1.0, we
need those installed. Since this is intended for jenkins use, we'll
also install a jenkins server.

We need a sane Ruby environment, and native extensions compiled in
some Gems, so the appropriate packages are installed. Then, the
vagrant-berkshelf plugin is installed for the "jenkins" user. Finally,
we install the required RubyGems into the system-wide Ruby.

Usage
=====

Add the recipe to the node or role where you wish to run test-kitchen
jenkins jobs. Additionally set the required jenkins server attributes.
For example, I'm using the following role for my jenkins server:

    {
      "name": "jenkins",
      "description": "Jenkins Build Server",
      "run_list": [
        "recipe[kitchen-jenkins]"
      ],
      "default_attributes": {
        "jenkins": {
          "server": {
            "home": "/var/lib/jenkins",
            "plugins": ["git-client", "git"],
            "version": "1.511",
            "war_checksum": "7e676062231f6b80b60e53dc982eb89c36759bdd2da7f82ad8b35a002a36da9a"
          }
        }
      },
      "json_class": "Chef::Role",
      "chef_type": "role"
    }

License and Author
==================

* Author: Joshua Timberman (<opensource@housepub.org>)

Copyright (c) 2013, Joshua Timberman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
