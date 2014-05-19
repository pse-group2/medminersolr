#medminersolr

Use ```git clone git@github.com:pse-group2/medminersolr.git``` to clone this project to your desired directory.

##Installation

###Requirements

The installation works on mac and linux. We will only describe the steps for linux here, but the commands on mac are very similar. We tested the installation on both Ubuntu 12.04 and 14.04.
In order to use the solr server, Java 7 needs to be installed. We used the standard openjdk-7 package preinstalled on the Ubuntu system.

###Ruby and Rails

The following commands download and install the latest version of Ruby on Rails. We tested it with Ruby v2.1.1 and Rails v4.1.1.
```
\curl -sSL https://get.rvm.io | bash -s stable --rails
source ~/.rvm/scripts/rvm
rvm use 2.1.1 (or the latest version)
```
To easily install the gems needed for the project, we use bundler:
```gem install bundler```
Rails also needs the nodejs package to work with javascript:
```sudo apt-get install nodejs```

###MySQL

To store all the downloaded wikipedia articles, we use a MySQL database. If you do not have MySQL installed, you can execute the following:
```
sudo apt-get install mysql-server mysql-client libmysqlclient-dev
```
During the installation, you get asked to enter a password for root. Do not forget this password. You can also leave the password blank. Finally, you have to edit the database.yml in the projects config/ folder and add your mysql connection data there. It should look like this:
```
development:
  adapter: mysql2
  database: dewiki
  username: root
  password: toor
  encoding: utf8
  port: 3306
  host: localhost
```

###Gems

All the required gems are specified in the Gemfile. To install them, you can use the bundler that we installed before with ```bundle install```.

If you get an error message saying that the JAVA_HOME path variable is not set, you have to do this in addition.

###Sunspot 

In a next step, you need to generate the sunspot installation files for you sunspot gem:
```
rails generate sunspot_rails:install
```
If you get asked to overwrite a file called sunspot.yml, you can do so.

###Treat

To setup the treat gem, simply run these operations:
```
sudo irb
require 'treat
Treat::Core::Installer.install 'german'
exit
```
###Filling the Database

In a next step, we have to download the wikipedia contents we want. To do this, run the update task ```rake wiki:update```. This will download the pages from the category medicine. In addition, a remover will delete all pages about persons.

###Starting the Application

Now, everything is installed and you are ready to go. First, start the Solr server with ```rake sunspot:solr:start```. Now, Solr has to create an index based on the database. This can be done by executing ```rake sunspot:solr:reindex```. This takes a while, but you have to do this only once. If it is finished, you can start the rails server with ```rails s``` and access the application at localhost:3000 in your browser.

