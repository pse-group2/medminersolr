#medminersolr

Use ```git clone git@github.com:pse-group2/medminersolr.git``` to clone this project to the desired directory.

##Installation

###Requirements

The installation works on Mac and Linux. We will only describe the steps for Linux here, but the commands on Mac are very similar. We tested the installation on both Ubuntu 12.04 and 14.04.
In order to use the solr server, Java 7 needs to be installed. We used the standard openjdk-7 package preinstalled on the Ubuntu system.

###Ruby and Rails

The following commands download and install the latest version of Ruby on Rails. We tested it with Ruby v2.1.1 and Rails v4.1.1.
```
\curl -sSL https://get.rvm.io | bash -s stable --rails
source ~/.rvm/scripts/rvm
rvm use 2.1.1
```
Instead of 2.1.1 you can also use the latest version of ruby.

For easy installation of the gems needed for the project, we use bundler:

```gem install bundler```
Rails also needs the nodejs package to work with javascript:
```sudo apt-get install nodejs```

###MySQL

To store all the downloaded Wikipedia articles, we use a MySQL database. To install MySQL, you can execute the following:
```
sudo apt-get install mysql-server mysql-client libmysqlclient-dev
```
During the installation, you will be asked to enter a password for root. Don't forget this password. You can also leave the password blank. Finally, you have to edit the database.yml in the project's config/ folder and add your MySQL connection data there. It should look like this:
```
development:
  adapter: mysql2
  database: <your database name>
  username: root
  password: <your password>
  encoding: utf8
  port: 3306
  host: localhost
```

Make sure that the database name is not already in use.

###Gems

All the required gems are specified in the Gemfile. To install them, you can use bundler which was installed before with ```bundle install```.

If you receive an error message saying that the JAVA_HOME path variable is not set, you have to do this in addition.

For two other gems, you need to run an extra installation to make them work. For the sunspot gem, you need to generate some installation files:
```
rake installation:sunspot
```
If you're asked to overwrite a file called sunspot.yml, you can do so.
To setup the treat gem for the german language, simply run this rake task:
```
rake installation:install_german
```
Now, all the gems should be installed properly.

###Filling the Database

In a next step, the Wikipedia articles will be downloaded and added to the database. To do this, run the update task ```rake wiki:update```. This will download the pages from the category "Medizin". In addition, all pages about people will be deleted. The data will be written into the database declared in the database.yml file. If the database does not exist, a new database with the name from the database.yml file will be created.

###Starting the Application

Now, everything is installed and you're ready to go. First, start the Solr server with ```rake sunspot:solr:start```. Next, Solr has to create an index based on the database. This can be done by executing ```rake sunspot:solr:reindex```. This takes a while, but you have to do this only once or when you update the database. When it has finished, you can start the rails server with ```rails s``` and access the application at localhost:3000 in your browser.

