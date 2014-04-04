utilities-metal
===============

Chef-metal definitions for my personal utilities server(s)

Usage
-----
Install all the dependencies with Berkshelf and run Chef Metal:

    bundle exec berks vendor
    bundle exec chef-client -c knife.rb -o \
        utilities::digitalocean,utilities::machines

To Do
-----
* Set up DNS for every machine
    * Is there a Namecheap gem that's not abandoned?
* Set up Datadog on every machine
