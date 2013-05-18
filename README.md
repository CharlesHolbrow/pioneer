Pioneer
=======

A minimalist blog written in CoffeeScript using Meteor and Meteorite

http://en.wikipedia.org/wiki/Pioneer_10


How To Use
==========

In the EC2 Dashboard
 - Launch Instance
 - Classic Wizard
 - Ubuntu Server 13.04, 64bit
 - Instance Type: T1 micro
 - Launch Into: EC2 Classic
 - Availability Zone - No Preference
 - On the "instance details" page use all the defaults
 - On the "create key pair" page, Create and download a new key pair - Do this now. you need th .pem file, and you won't be able to download it later for security reasons
 - In Configure firewall - "quicklaunch-1" opens the ports for http and ssh

Once the instance is 'running', ssh in. Install node, mongodb, meteor, meteorite, and git

```
$ ssh -i <path-to-your-pem-file> ubuntu@<your-public-dns.amazonaws.com>
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install git
sudo apt-get install nodejs
curl https://install.meteor.com | /bin/sh
sudo npm install -g meteorite
sudo apt-get install mongodb
 ```
Now clone your meteor project using the https protocol

```
git clone https://github.com/<user>/<repo>.git
```
To run the server in production mode, first bundle it using meteorite. and then extract the bundle in the current directory.

```
cd yourMeteorProject
sudo mrt bundle bundle.tgz # error without sudo
tar -zxvf bundle.tgz
```

Now create the following environment variables remember when you did meteor.create app-name? you will need it again here:

```
export PORT=80
export MONGO_URL=mongodb://localhost:27017/<app-name>
export ROOT_URL=http://<your-public-dns.amazonaws.com>
```

because of some weird glitch we now have to uninstall and install fibers

```
cd bundle/server
npm uninstall fibers
sudo npm install fibers
cd ../..
```

Finally now you can launch. since are are on port 80, we need sudo. the -E flag tells sudo to use the current environment variables instead of 'sudoing' in a new shell

```
sudo -E node bundle/main.js
```

NOTES
=====
Why doesn't mrt bundle work without sudo?

https://github.com/oortcloud/meteorite/issues/117

Source for fibers glitch:

http://stackoverflow.com/questions/13327088/meteor-bundle-fails-because-fibers-node-is-missing

TEST
====
Can we move the bundle to another dir? If so, does that fix the fibers glitch?

If we setup our dns, we should be able to use myapp.com for ROOT_URL. Test.
