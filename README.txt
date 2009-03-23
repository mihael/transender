transender
    by KitschMaster
    kitschmaster.com

== DESCRIPTION:

Use Transender whenever you need to git-clone and rename XCode iPhone SDK projects.

Project home: http://kitschmaster.com/kiches/246


== FEATURES/PROBLEMS:

* can clone XCode projects (on git) and rename them successfully (tested only on iPhone/iPod Touch projects)
* use from command line or ruby program

== SYNOPSIS:

You could use it in a Rails app maybe like this:

  Transender::Ji.transform_and_zip({:app_title=>"myClonedProject", :transform=>"git://github.com/mihael/iproject.git", :ji_path => File.join(File.dirname(__FILE__), %w[.. tmp]) }) do |zip|
    render :text => zip
  end

Or on the command line, like this:

  transender git://github.com/mihael/iproject.git myFreshProject /projects/

== REQUIREMENTS:

Nothing you would not have. Only the simple tools.

* sed
* tar
* git
* ruby

== INSTALL:

GitHub style:

* gem sources -a http://gems.github.com
* sudo gem install mihael-transender

RubyForge style:

* sudo gem install transender

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIXME (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
