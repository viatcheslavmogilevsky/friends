require 'spec_helper'



describe HomeController do
	render_views

	before(:each) do
		@user = FactoryGirl.create(:user)
	end

	describe "index action" do
		it "should show home page for guests" do
			get :index 
			response.body.should include("Welcome to the my test app!</p>")
		end

		it "should show feed page for users" do
			sign_in(@user)
			get :index
			response.should redirect_to feed_path
		end
	end

end