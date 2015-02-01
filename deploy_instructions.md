##Initial Setup

1. Create Dokku/Docker Droplet on Digital Ocean
2. Got to the Droplet's ip address on port 2000 and fill out the details
3. ssh in as root and run:

    `cd /var/lib/dokku/plugins`
	`git clone https://github.com/Kloadut/dokku-pg-plugin postgresql`
    `git clone https://github.com/statianzo/dokku-shoreman.git`
	`dokku plugins-install`
	
4. Add: dokku@ip address (not **git@**) to local repo:
	`git remote add dokku dokku@IPADDRESS:APP NAME`
5. Setup dokku database:
    `dokku postgresql:create test-app`
6. Push to dokku, consider procfile:
    `git push dokku master`

7. Check it's running:
	`docker ps -a`
8. Setup Rails:

	`dokku run APP NAME rake db:migrate`
	`dokku run APP NAME rake db:seeds`

9. Link to nginx:
	`nginx:build-config APP NAME`
10. Check where it's running:
	`dokku urls test-app`

##Other Notes
**Procfile Contents:**

	web: bundle exec rails server -p $PORT
	worker:  bundle exec rake jobs:work

**Restart App:**

	dokku deploy APP NAME
