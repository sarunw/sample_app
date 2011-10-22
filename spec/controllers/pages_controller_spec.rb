require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end
  
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                                    :content => @base_title + "Home")
    end
    
    
    # Exercise 11
    describe "signed-in user" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
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
      
      it "should not have a delete links for other microposts"
      
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
