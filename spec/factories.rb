FactoryGirl.define do
  factory :post do
    content "Post content"
    association :target_user
    association :user
  end

  factory :user do
  	name "John"
  	first_name "Smith"
  	nickname "Nick"
  	description "User description"
  	password "123456"
  	password_confirmation "123456"
  	email "josh@smith.com"
  end

  factory :comment do
  	content "Comment content"
  	association :user
  	association :commentable
  end

  sequence :content do |n|
  	"content #{n}"
  end

  sequence :email do |n|
  	"example@n#{n}.com"
  end

  factory :photo_album do
    name "photo album"
    description "photo album description"
    association :user
  end

  factory :message do
    association :user
    association :target_user
    content "Hello user"
    mark nil
  end

  factory :user_friendship do
    association :user
    association :target_user
  end
end

Factory.define :photo do |f|
  include ActionDispatch::TestProcess
  f.description "Photo description"
  f.association :user
  f.association :photo_album
  f.content fixture_file_upload("app/assets/images/rails.png","image/png")
end