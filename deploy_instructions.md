##Initial Setup

1. Create Ubuntu 14.04 droplet on Digital Ocean
2. Install dokku-alt `sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/dokku-alt/dokku-alt/master/bootstrap.sh)"`
3. Visit: `http://<ip>:2000/`
4. ssh in as root and:

    `cd /var/lib/dokku/plugins`
	`git clone https://github.com/neam/dokku-custom-domains.git`
	`dokku plugins-install`
	
5. Setup dokku database:
    `dokku postgresql:create APP_NAME`
	
6. Add: dokku@ip address (not **git@**) to local repo:
	`git remote add dokku dokku@IPADDRESS:APP_NAME`

7. Push to dokku, consider procfile:
    `git push dokku master`

8. Check it's running:
	`docker ps -a`
	
9. Setup:

```
postgresql:link APP_NAME APP_NAME
dokku run APP_NAME rake db:migrate	
dokku run APP_NAME rake db:seeds
```

10. Set the domains:
	`dokku domains:set www.1.com 1.com 2.com www.2.com`

11. Check where it's running:
	`dokku urls APP_NAME`

##Other Notes
**Procfile Contents:**

	web: bundle exec rails server -p $PORT
	worker:  bundle exec rake jobs:work

**Restart App:**

	dokku deploy APP_NAME
