require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end
  
  describe "GET 'home'" do
    
    describe "when not signed in" do
      
      before(:each) do
        get :home
      end
      
      it "should be successful" do
        response.should be_success
      end
    
      it "should have the right title" do
        response.should have_selector("title",
                                      :content => @base_title + "Home")
      end
    end
    
    # Exercise 11
    describe "when signed in" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end
      
      it "should display proper micropost count" do
        content = "Lorem ipsum dolor sit amet"
        get 'home'
        response.should have_selector("span.microposts", :content => "0")
        response.should have_selector("span.microposts", :content => "micropost")
        
        @user.microposts.create!(:content => content)
        get 'home'
        response.should have_selector("span.microposts", :content => "1")
        response.should have_selector("span.microposts", :content => "micropost")

        @user.microposts.create!(:content => content)
        get 'home'
        response.should have_selector("span.microposts", :content => "2")
        response.should have_selector("span.microposts", :content => "microposts")
        
      end
      
      it "should paginate microposts" do
        31.times do
          @user.microposts.create!(:content => "content")
        end

        get :home
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Next")
      end
      
      it "should not have a delete links for other microposts" do
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.microposts.create!(:content => "content")
        @user.follow!(other_user)
        
        get :home
        response.should have_selector("span.content", :content => "content")
        response.should_not have_selector("a", :content => "delete")
      end
        
      
      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
      
    end
      
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => @base_title + "Contact")
    end
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + "About")
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                                    :content => @base_title + "Help")
    end
  end
  

end
