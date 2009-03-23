require File.join(File.dirname(__FILE__), %w[spec_helper])
include Transender

describe Transender do
  
  it "should not be instantiated without cool arguments" do
    lambda { Ji.new(  ) }.should raise_error
    lambda { Ji.new( "not Hash" ) }.should raise_error(ArgumentError)
  end  

  it "should be instantiated with fine hashish" do
    lambda { Ji.new( {:app_title=>"xyzproject", :transform=>"iproject", :ji_path=>""}  ) }.should_not raise_error    
  end

  it "should clone and remove git" do
    ji = Ji.new({:app_title=>"xyzproject", :transform=>File.join(File.dirname(__FILE__), %w[.. iproject]), :ji_path => File.join(File.dirname(__FILE__), %w[.. tmp]) })
    ji.clone_and_remove_git
    File.exists?(ji.app_path).should be(true)
    File.exists?(File.join(ji.app_path, '.git')).should be(false)
    File.exists?(File.join(ji.app_path, 'build')).should be(false)
  end

  it "should clone and remove git and rename" do
    ji = Ji.new({:app_title=>"xyzproject", :transform=>File.join(File.dirname(__FILE__), %w[.. iproject]), :ji_path => File.join(File.dirname(__FILE__), %w[.. tmp]) })
    ji.clone_and_remove_git
    ji.rename
    puts File.exists?(File.join(ji.app_path)).should be(true)
  end


  it "should transform and zip" do 
    proc do
       Ji.transform_and_zip({:app_title=>"xyzproject", :transform=>File.join(File.dirname(__FILE__), %w[.. iproject]), :ji_path => File.join(File.dirname(__FILE__), %w[.. tmp]) }) do |zip|
         zip.should == File.join(File.dirname(__FILE__), %w[.. tmp xyzproject.zip])
         File.exists?(zip).should == true
       end
    end.should_not raise_error
  end

  it "should transform and zip a remote git project" do 
    proc do
       Ji.transform_and_zip({:app_title=>"freshproject", :transform=>" git://github.com/mihael/iproject.git", :ji_path => File.join(File.dirname(__FILE__), %w[.. tmp]) }) do |zip|
         zip.should == File.join(File.dirname(__FILE__), %w[.. tmp freshproject.zip])
         File.exists?(zip).should == true
       end
    end.should_not raise_error
  end

end
