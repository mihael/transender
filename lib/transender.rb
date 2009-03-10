require 'fileutils'
require 'ftools'

module Transender

  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  v = YAML.load_file(File.join(File.dirname(__FILE__), %w[.. VERSION.yml]))
  VERSION = "#{v[:major]}.#{v[:minor].v[patch]}" 
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
  
  def self.extract_app_title(giturl)
    giturl.split('/').last.split('.').first
  end
  
  #Transender - Ji
  class Ji
    attr_accessor :options, :app_title, :app_path, :transform, :transform_title, :ji_path, :id

    # Supply a Hash of options containing:
    # :app_title - your fresh apps title
    # :transform - git repository of the base project - app_title becomes a clone of it
    # :ji_path - output dir
    def initialize(options)
      raise ArgumentError unless options.class == Hash && options[:app_title] && options[:transform] && options[:ji_path]
      @options = options
      @app_title = @options[:app_title]
      @transform = @options[:transform]
      @transform_title = Transender.extract_app_title(@transform)
      @ji_path = @options[:ji_path]
      @app_path = File.join(@ji_path, @app_title)
      @id = Time.now.strftime("%Y-%m-%d-%s")    
    end
    
    #clones from transform then removes git
    def clone_and_remove_git
      #prepare destination without any warning
      `rm -rf #{@app_path}`
      #clone that git repo and rename at the same time
      `git clone #{@transform} #{@app_path}`
      #remove any past life remains from the fresh project
      `rm -rf #{File.join(@app_path, 'build')}`
      `rm -rf #{File.join(@app_path, '.git')}`
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
     `rm -rf #{z}` #remove any previous zips without any warnings
      Transender.zip_dir(File.join(ji_path, app_title), z)
      puts "Zipped #{app_title} into #{z}" if File.exists?(z)
      z
    end
    
    def transform
      clone_and_remove_git
      rename
      zip
    end

    #Use maybe like this: Transender::Ji.transform_and_zip(ahash) {|zip| render :text => zip}
    def self.transform_and_zip(t={}, &block)
      zip = Ji.new(t).transform
      yield zip if block
    end

    private

    def rename_files
      FileUtils.mv "#{app_path}/#{transform_title}.xcodeproj", "#{app_path}/#{app_title}.xcodeproj"
      Dir["#{app_path}/*.{m,h,pch}"].each do |filename|
        if filename =~ /#{transform_title}/
            FileUtils.mv filename, filename.gsub(/#{transform_title}/, app_title)
        end
      end
      Dir["#{app_path}/Classes/*.{m,h}"].each do |filename|
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
      Dir["#{app_path}/Classes/*.{m,h}"].each do |filename|
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

  end # class Ji

end  # module Transender

Transender.require_all_libs_relative_to(__FILE__)

# EOF
