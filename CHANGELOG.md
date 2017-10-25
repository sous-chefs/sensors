sensors Cookbook CHANGELOG
==========================
This file is used to list changes made in each version of the sensors cookbook.

v1.1.6
------
- Remove the Gemfile
- Add a TESTING.md file
- Add a CONTRIBUTING.md file

v1.1.5
------
- Swap the Rakefile for Delivery local mode
- Update the ignore files
- Remove the rubocop.yml file since we're using cookstyle now
- Test in Travis using ChefDK
- Cookstyle fixes
- Add long_description metadata
- Add chef_version metadata
- Require Chef 12.1 or later since Chef 11 is EOL
- Update the Chefspecs to do a bit more
- Use a SPDX compliant license string


v1.1.4
------
- Add changelog
- Use stanard chef .gitignore file
- Remove most of the rule disables in the rubocop file
- Use travis container environment and test on Ruby 2.2
- Update the supermarket URL in the berksfile
- Update and breakout the deps in the Gemfile
- Add a license file
- Add a cookbook version badge
- Set the minimum supported Chef version to 11 in the readme
- Add more files to the chefignore file
- Add fedora to the metadata as a supported platform
- Add issues_url and source_url to the metadata file
- Update specs to Chefspec 4 format
