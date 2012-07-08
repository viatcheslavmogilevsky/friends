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

user1.target_users << user2
user2.friendship_notifications(true).first.accept

p11 = user1.posts.create({:content => "josh text1 for self"})
user1.wall_items << p11

p21 = user2.posts.create({:content => "helene text1 for self"})
user2.wall_items << p21

p12 = user1.posts.create({:content => "josh text2 for self"})
user1.wall_items << p12

p22 = user2.posts.create({:content => "helene text2 for self"})
user2.wall_items << p22

p13 = user1.posts.create({:content => "josh text4 for self"})
user1.wall_items << p13

p14 = user1.posts.create({:content => "josh text4 for self"})
user1.wall_items << p14