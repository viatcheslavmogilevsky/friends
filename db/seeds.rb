# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)




user1 = User.create({:name => 'Josh', 
	:first_name => 'Ford', 
	:description => 'I am bad boy',
	:nickname => 'Pirate',
	:password => '123456',
	:password_confirmation => '123456',
	:email => 'josh@ford.com'})

user2 = User.create({:name => 'Helene', 
	:first_name => 'Smith', 
	:description => 'I am princesse',
	:nickname => 'Shine',
	:password => '123456',
	:password_confirmation => '123456',
	:email => 'helene@smith.com'})	

#user1.target_users << user2