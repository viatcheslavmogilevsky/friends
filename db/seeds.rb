# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require "ffaker"

#creating users

entries = Dir.glob("./public/images/*").entries

50.times do |n|
	name = Faker::Name.first_name
	first_name = Faker::Name.last_name
	case rand(10)
	when 0..3
		nickname = Faker::HipsterIpsum.word 
	else
		nickname = nil
	end
	description = Faker::Lorem.sentence(6)
	password = "123456"
	password_confirmation = "123456"
	email = "example_#{n}@mail.com"
	case rand(10)
	when 4..9
		avatar = File.open(entries.sample)
	else
		avatar = nil
	end
	user = User.new(:name => name, :first_name => first_name,
		:nickname => nickname, :description => description,
		:password => password, :password_confirmation => password_confirmation, :email => email)
	user.avatar = avatar
	user.save!
end

30.times do |i|
	user = User.find(i+1)
	friends = User.limit(5).offset(i+1)
	friends.each do |friend|
		user.target_users << friend
		friend.friendship_notifications.first.accept
	end
end

User.all(:limit => 25).each do |user|
	10.times do
		post = user.posts.create(:content => Faker::Lorem.paragraph)
		user.wall_items << post
	end
end





