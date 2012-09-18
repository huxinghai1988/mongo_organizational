# MongoOrganizational

Installation
Add this line to your application's Gemfile:

	gem 'mongo_organizational'

Add this line to your application's Gemfile:

    gem "mongo_organizational", :github => "lshgo/mongo_organizational"

Models add

    include Mongoid::Organizational

Switch database 

    Mongoid::Organizational::Sessions.switch_organization(database_name)
  
Or install it yourself as:

    $ gem install mongo_organizational
 