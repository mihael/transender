require 'fileutils'
require 'yaml'

module Transender

  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  V = YAML.load_file(File.join(File.dirname(__FILE__), %w[.. VERSION.yml]))
  VERSION = "#{V[:major]}.#{V[:minor]}.#{V[:patch]}" 
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

  #replaces all 'old' strings with 'fresh' strings
  def self.replace_in_file( in_file, old, fresh, out_file)
     `sed 's/#{old}/#{fresh}/g' <'#{in_file}' >'#{out_file}'`
  end

  def self.replace_strings_in_file(old, fresh, filename)
    temp = "#{filename}.temp"
    FileUtils.mv filename, temp
    Transender.replace_in_file(temp, old, fresh, filename)
    FileUtils.rm temp
  end

  def self.zip_dir(dir, out_file)
    `tar cvfz '#{out_file}' '#{dir}'`
    out_file
  end

  def self.extract_name(url)
    url.split('/').last.split('.').first
  end
  
  #Transender - Ji
  class Ji
    attr_accessor :options, :app_title, :app_path, :transform, :transform_title, :ji_path, :abowl_path, :abowl_yml, :id

    # Supply a Hash of options containing:
    # options[:app_title]:: your fresh apps title
    # options[:transform]:: git repository of the base project - app_title becomes a clone of it
    # options[:ji_path]:: output dir
    def initialize(options)
      raise ArgumentError unless options.class == Hash && options[:app_title] && options[:transform] #&& options[:ji_path]
      @options = options
      @ji_path = @options[:ji_path] || Dir.getwd
      @ji_path = Dir.getwd if @ji_path.empty?
      puts "Ji path is: #{@ji_path}"
      unless File.exists? @ji_path
        begin
          FileUtils.mkdir @ji_path
        rescue 
          puts "Output path could not be created."
          raise ArgumentError
        end
      end
      @app_title = @options[:app_title]
      @app_path = File.join(@ji_path, @app_title)
      @abowl_path = File.join(@ji_path, "abowl")
      @abowl_yml = File.join(@abowl_path, "abowl.yml")
      @transform = @options[:transform]
      @transform_title = Transender.extract_name(@transform)
      @id = Time.now.strftime("%Y-%m-%d-%s")
    end
    
    #read abowl, transend that information into existing project
    #deleting, copying files in this proces
    def transend
      if read_abowl 
        
        # handle artwork if any
        files = Dir["#{abowl_path}/Artwork/*"]
        if files&&files.size>0
          #remove original artwork
          FileUtils.rm_rf "#{app_path}/Artwork"
          #copy this bowls artworks
          FileUtils.cp_r "#{abowl_path}/Artwork", "#{app_path}/"
        end

        # handle transends if any
        files = Dir["#{abowl_path}/Transends/*"]
        if files&&files.size>0
          #remove original transends
          FileUtils.rm_rf "#{app_path}/Transends"
          #copy this bowls transends
          FileUtils.cp_r "#{abowl_path}/Transends", "#{app_path}/"
        end
        
        # handle files
        ['Controllers', 'Filters'].each do |type|
          filenames = @abowl['files'][type]
          if filenames&&filenames.size>0
            Dir["#{app_path}/Classes/#{type}/*.{m,h}"].each do |file|
              name = Transender.extract_name(file)
              FileUtils.rm file unless filenames.member? name
            end
          end
        end
        filenames = @abowl['files']['Views']
        if filenames&&filenames.size>0
          Dir["#{app_path}/Views/*.{xib, nib}"].each do |file|
            name = Transender.extract_name(file)
            FileUtils.rm file unless filenames.member? name
          end
        end

        #handle app delegate defines
        defines = @abowl['app']
        appDelegate = "#{app_path}/Classes/Application/#{app_title}AppDelegate.h"
        appDelegate_temp = "#{app_path}/Classes/Application/#{app_title}AppDelegate.h.temp"
        File.open(appDelegate_temp, "w") do |outfile|
          File.open(appDelegate, "r") do |infile|
            while (line = infile.gets)
              if line =~ /#define/
                key = line.split[1]
                if defines.has_key? key
                  value = defines[key]
                  if value.to_s =~ /^(\d)*\.(\d)*$/ #is numerical
                    outfile << (line.gsub /^#define #{key} .*$/, "#define #{key} #{value}")
                    puts "#define #{key} #{value}"
                  else
                    outfile << (line.gsub /^#define #{key} .*$/, "#define #{key} @\"#{value}\"")
                    puts "#define #{key} #{value}"
                  end
                end
              else
                outfile << line
              end
            end
          end
        end
        FileUtils.mv appDelegate_temp, appDelegate
        
        puts "Transended #{@abowl['app']['APP_TITLE']}."

      else #try to make a bowl then
        make_abowl
      end
    end
    
    #clones from transform then removes git
    def clone_and_remove_git
      #prepare destination without any warning
      FileUtils.rm_rf @app_path #`rm -rf #{@app_path}`
      
      if Object.const_defined? 'RSPEC'
        #todo 
        #this does not create a .git inside the cloned project
        `git --work-tree=#{@app_path} --git-dir=#{@app_path}/.git clone --no-hardlinks #{@transform} #{@app_path}`
      else
        `git clone --no-hardlinks #{@transform} #{@app_path}`
      end
      
      #remove any past life remains from the fresh project
      FileUtils.rm_rf File.join(@app_path, 'build') #`rm -rf #{File.join(@app_path, 'build')}`
      FileUtils.rm_rf File.join(@app_path, '.git')  #`rm -rf #{File.join(@app_path, '.git')}`

      puts "Cloned from #{@transform} into #{@app_path}."
    end

    #renames within project app_title
    def rename
      todo = ""
      if rename_files
        if replace_strings_in_files
        else
          todo << 'TODO: You need to replace some strings in some files manually. Thanks.\n'
        end
      else
        todo << 'TODO: You need to rename some files manually. Thanks.\n'
      end
      todo = todo.empty? ? "Renamed/replaced occurences of #{transform_title} to #{app_title}." : todo
      puts todo
    end

    def zip
      z = File.join(ji_path, "#{app_title}.zip")
      FileUtils.rm_rf z #`rm -rf #{z}` #remove any previous zips without any warnings
      
      #cd into and zip
      `cd #{ji_path}; tar cvfz #{app_title}.zip #{app_title}/`

      #return path to zip
      puts "Zipped #{app_title} into #{z}" if File.exists?(z)
      z
    end
    
    def transformize
      clone_and_remove_git
      rename
      zip
    end

    def transendize
      clone_and_remove_git
      rename
      transend
      zip
    end

    #Use maybe like this: Transender::Ji.transform_and_zip(ahash) {|zip| render :text => zip}
    def self.transform_and_zip(t={}, &block)
      zip = Ji.new(t).transformize
      yield zip if block
    end

    #Use maybe like this: Transender::Ji.transend_and_zip(ahash) {|zip| render :text => zip}
    def self.transend_and_zip(t={}, &block)
      zip = Ji.new(t).transendize
      yield zip if block
    end

    #Transender::Ji.transend
    #if there is abowl, it will be used for transending
    def self.transend(t={})
      ji = Ji.new(t)
      ji.clone_and_remove_git
      ji.rename
      ji.transend
    end

    private

    def rename_files
      FileUtils.mv "#{app_path}/#{transform_title}.xcodeproj", "#{app_path}/#{app_title}.xcodeproj"
      Dir["#{app_path}/*.{m,h,pch}"].each do |filename|
        if filename =~ /#{transform_title}/
            FileUtils.mv filename, filename.gsub(/#{transform_title}/, app_title)
        end
      end
      Dir["#{app_path}/Classes/**/*.{m,h}"].each do |filename|
        if filename =~ /#{transform_title}/
            FileUtils.mv filename, filename.gsub(/#{transform_title}/, app_title)
        end
      end
      true
    rescue
      puts $!
      false
    end
    
    def replace_strings_in_files
      Dir["#{app_path}/*.{m,h,pch,xib}"].each do |filename|
        Transender.replace_strings_in_file(transform_title, app_title, filename)
      end
      Dir["#{app_path}/Views/*.{m,h,pch,xib}"].each do |filename|
        Transender.replace_strings_in_file(transform_title, app_title, filename)
      end
      Dir["#{app_path}/Classes/**/*.{m,h}"].each do |filename|
        Transender.replace_strings_in_file(transform_title, app_title, filename)
      end
      Dir["#{app_path}/#{app_title}.xcodeproj/*.*"].each do |filename|
        Transender.replace_strings_in_file(transform_title, app_title, filename)
      end
      true
    rescue
      puts $!
      false
    end

    private 
    
    def has_abowl?
      File.exists? @abowl_yml
    end
    
    def make_abowl
      unless File.exists? @abowl_yml #do not overwrite
          FileUtils.cp_r File.join(LIBPATH, "abowl"), @ji_path
      end
    rescue 
      puts "Could not make abowl."
    end
    
    def read_abowl
      @abowl = YAML.load_file @abowl_yml
    rescue 
      puts "Could not read abowl."
      nil
    end

  end # class Ji

end  # module Transender

Transender.require_all_libs_relative_to(__FILE__)

# EOF
