# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'guard/guard'
require 'mixlib/shellout'

module ::Guard
  class Kitchen < ::Guard::Guard
    def start
      ::Guard::UI.info("Guard::Kitchen is starting")
      cmd = Mixlib::ShellOut.new("kitchen create")
      cmd.live_stream = STDOUT
      cmd.run_command
      begin
        cmd.error!
        Notifier.notify('Kitchen created', :title => 'test-kitchen', :image => :success)
      rescue Mixlib::ShellOut::ShellCommandFailed => e
        Notifier.notify('Kitchen create failed', :title => 'test-kitchen', :image => :failed)
        ::Guard::UI.info("Kitchen failed with #{e.to_s}")
        throw :task_has_failed
      end
    end

    def stop
      ::Guard::UI.info("Guard::Kitchen is stopping")
      cmd = Mixlib::ShellOut.new("kitchen destroy")
      cmd.live_stream = STDOUT
      cmd.run_command
      begin
        cmd.error!
      rescue Mixlib::ShellOut::ShellCommandFailed => e
        ::Guard::UI.info("Kitchen failed with #{e.to_s}")
        throw :task_has_failed
      end
    end

    def reload
      stop
      start
    end

    def run_all
      ::Guard::UI.info("Guard::Kitchen is running all tests")
      cmd = Mixlib::ShellOut.new("kitchen verify")
      cmd.live_stream = STDOUT
      cmd.run_command
      begin
        cmd.error!
        Notifier.notify('Kitchen verify succeeded', :title => 'test-kitchen', :image => :success)
        ::Guard::UI.info("Kitchen verify succeeded")
      rescue Mixlib::ShellOut::ShellCommandFailed => e
        Notifier.notify('Kitchen verify failed', :title => 'test-kitchen', :image => :failed)
        ::Guard::UI.info("Kitchen verify failed with #{e.to_s}")
        throw :task_has_failed
      end
    end

    def run_on_changes(paths)
      suites = {}
      paths.each do |path|
        path =~ /test\/integration\/(.+?)\/.+/
        suites[$1] = true
      end
      ::Guard::UI.info("Guard::Kitchen is running suites: #{suites.keys.join(' ')}")
      cmd = Mixlib::ShellOut.new("kitchen verify '(#{suites.keys.join('|')})-.+' -p")
      cmd.live_stream = STDOUT
      cmd.run_command
      begin
        cmd.error!
        Notifier.notify("Kitchen verify succeeded for: #{suites.keys.join(', ')}", :title => 'test-kitchen', :image => :success)
        ::Guard::UI.info("Kitchen verify succeeded for: #{suites.keys.join(', ')}")
      rescue Mixlib::ShellOut::ShellCommandFailed => e
        Notifier.notify("Kitchen verify failed for: #{suites.keys.join(', ')}", :title => 'test-kitchen', :image => :failed)
        ::Guard::UI.info("Kitchen verify failed with #{e.to_s}")
        throw :task_has_failed
      end
    end
  end
end

guard 'rspec', :cli => "--color" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^recipes/(.+)\.rb$}) { |m| "spec/unit/recipes/#{m[1]}_spec.rb" }
  watch(%r{^attributes/(.+)\.rb$})
  watch(%r{^files/(.+)})
  watch(%r{^templates/(.+)})
  watch(%r{^providers/(.+)\.rb}) { |m| "spec/unit/providers/#{m[1]}_spec.rb" }
  watch(%r{^resources/(.+)\.rb}) { |m| "spec/unit/resources/#{m[1]}_spec.rb" }
end

guard 'kitchen' do
  watch(%r{test/.+})
end
