nginx-site CHANGELOG
====================

This file is used to list changes made in each version of the nginx-site cookbook.

0.2.6
-----
- Added fastcgi_read_timeout

0.2.3
-----
- Added PHP 5.5 Recipe
	to use it add to run list "recipe[nginx-site::php55@0.2.3]"
    this calls the php55 recipe instead
- Added ldap.conf file that is copied over if using ldap / php.  This allows for self signed certs

0.2.2
-----
- Updated cookbook to work smoother with Chef11
- Changed the default error logging for PHP
- Modified config file to use a rewrite file if present.

0.1.0
-----
- TAMU - Initial release of nginx-site

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
