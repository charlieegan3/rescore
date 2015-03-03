#How to Contribute
1. `cd` into the rescore directory
2. `git branch` this tells you what branch you're on
3. If you're **not** on `master` then do: `git checkout master`
4. Now do: `git pull origin master` this means **you're up to date** with the latest approved changes

Now you're ready to actually start!

1. Do create a new branch do: `git checkout -b name_of_branch`
2. You're now ready to start making code changes
3. Make changes to implement your feature **(the tricky part)**
4. When you think it looks good do: `git status` and take a look at the changes you've made
5. Make sure you know ***why*** you're making edits to **all the files** listed as modified.
6. if you're happy do: `git add .` 
7. Your changes are now ready to be *committed*
8. Commit by doing: `git commit -m "What you have done, no longer than 60chrs"`
9. If you're not done then you can keep working, otherwise, if it's **ready for review** continue...

Now you're ready to share your code!

1. Do: `git push origin name_of_branch` to publish the changes on GitHub
2. Now open a PR, it'll prompt you to open one when you visit [the repo](https://github.com/charlieegan3/rescore), it's a yellow bar notification and it has a green button to Compare and PR
3. Click it and fill out the form - then submit it.
4. **DO NOT MERGE** it without having it reviewed by @charlieegan3 or @IllegalCactus
5. When you get to that stage further steps can be discussed in the comments.

#Admin account

**Username:** admin
**Password** 1234qwer

#Style
Just some quick notes on code style.

* No inline styles
* CSS selectors look like:

```
    .class {
    	property: value;
    }
```
* Ruby blocks look like this: `thing.map { |item| }`
* Ruby and Slim is indented with **2 spaces**, not tabs.
* Only make commits where you need them, none of this, `change`, `and fix for it`, `oops, forgot to make it actually work`. There is a flag for git commit `--amend` - this will append to the previous commit.

This list will likely grow :) 

#Editors
Use what you like - but **use Sublime Text 3**.

You should have Package Control and install at least these two packages:
1. Ruby Slim
2. Gitgutter

To install package control:

Copy (the entire line):

```
import urllib.request,os,hashlib; h = '2deb499853c4371624f5a07e27c334aa' + 'bf8c4e67d14fb0525ba4f89698a6d7e1'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```
Open Sublime and press `ctrl` + ` (backtick)

Paste that ^ in - press enter.

Press `ctrl` + `shift` + `p` and type `Install Package` to access the package list.

###Preferences

I would recommend using the preferences similar to the following:

```
{
	"draw_white_space": "all",
	"ensure_newline_at_eof_on_save": true,
	"expand_tabs_on_save": true,
	"highlight_modified_tabs": true,
	"indent_guide_options":
	[
		"draw_active"
	],
	"indent_to_bracket": true,
	"rulers":
	[
		80
	],
	"tab_size": 2,
	"translate_tabs_to_spaces": true,
	"trim_trailing_white_space_on_save": true
}
```

* `expand_tabs_on_save` comes from a package, it's good but not essential
* `rulers` 80 is a good guide for **max line length**


