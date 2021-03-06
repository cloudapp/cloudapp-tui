## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'cloudapp-tui'
  s.version           = '1.0.0.beta.1'
  s.date              = '2012-10-08'
  s.rubyforge_project = 'cloudapp-tui'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "CloudApp TUI"
  s.description = "Experimental text user interface for CloudApp using ncurses."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Larry Marburger"]
  s.email    = 'larry@marburger.cc'
  s.homepage = 'https://github.com/cloudapp/cloudapp-tui'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## If your gem includes any executables, list them here.
  s.executables = ["cloudapp"]

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md MIT-LICENSE]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency 'cloudapp-service', '~> 1.0.0.beta.1'
  s.add_dependency 'clipboard'
  s.add_dependency 'ffi-ncurses'
  s.add_dependency 'highline'

  # Needed for Highline echo=false support as per
  # https://github.com/JEG2/highline/issues/39
  s.add_dependency 'ruby-termios'

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency 'rake'
  s.add_development_dependency 'ronn'
  s.add_development_dependency 'rspec'

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    MIT-LICENSE
    README.md
    Rakefile
    bin/cloudapp
    cloudapp-tui.gemspec
    lib/cloudapp/tui.rb
    lib/cloudapp/tui/config.rb
    lib/cloudapp/tui/drops.rb
    lib/cloudapp/tui/drops_renderer.rb
    lib/cloudapp/tui/filters.rb
    lib/cloudapp/tui/help.rb
    lib/cloudapp/tui/renderer.rb
    spec/cloudapp/cli/config_spec.rb
    spec/cloudapp/cli/drops_renderer_spec.rb
    spec/cloudapp/cli/drops_spec.rb
    spec/cloudapp/cli/filters_spec.rb
    spec/cloudapp/cli/help_spec.rb
    spec/cloudapp/cli/renderer_spec.rb
    spec/helper.rb
    spec/support/navigable_collection_example.rb
    spec/support/renderable_double.rb
    spec/support/renderable_example.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  # s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
