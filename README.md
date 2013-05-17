Pioneer
=======

A minimalist blog written in CoffeeScript using Meteor and Meteorite

http://en.wikipedia.org/wiki/Pioneer_10


How To Use
==========

Install node.js

Install meteor (www.meteor.com)

Install meteorite (https://github.com/oortcloud/meteorite)
```
$ sudo -H npm install -g meteorite
```


Because we are using meteorite and the Router smart package from Atmoshpere we cannot deploy to meteor.com. Instead try deploying to AWS using the meteoric script

Install meteoric (https://github.com/julien-c/meteoric.sh)
```
$ curl https://raw.github.com/julien-c/meteoric.sh/master/install | sh
```

Once meteoric is installed, setup meteoric.config.sh credentials file as described on the meteoric github page.

Now setup and deploy to AWS with the following commands:
```
$ meteoric setup
$ meteoric deploy
```
