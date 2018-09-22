### Onboarding


## Requirements

Nomos requires PHP6, NGINX, and MySQL.

For development, we use Vagrant to automatically generate a self-contained development environment.
Read the "Contributing" page before starting to install stuff!


## Test Server Installation
1. Go [here](https://github.com/vhs/nomos/wiki/Contributing)
2. Follow the instructions carefully
3. You're done! Please tell us if you have any issues so we can improve the docs


## Production Server Provisioning

Stay tuned! We haven't done this from scratch yet.


## Production Deployments for VHS

SSH to Krampus with public key auth as your user.

    $ sudo su - deploy -c './deploy.sh'

Then wait