# Deploy Scripts for WordPress Plugins and Themes

These scripts expect the following directory structure where `your-plugin-slug` is 
the slug of your plugin in the WordPress plugin repository:

	your-plugin-slug
	 |
	 +-- git (your Git repo)
	 |   |
	 |   +-- .git
	 |   +-- readme.md
	 |   +-- your-plugin-slug.php
	 |   +-- ...
	 |
	 +-- svn (your SVN repo)
	 |   |
	 |   +-- assets
	 |   +-- trunk
	 |   +-- tags
	 |   +-- ...
	 |   
	 +-- wp-deploy (this repo)
	 |   |
	 |   +-- .git
	 |   +-- deploy.sh
	 |   +-- tag.sh
	 |   +-- ...

### Credits

Based on ["Deploying from git to svn" by Scribu](http://scribu.net/blog/deploying-from-git-to-svn.html)

