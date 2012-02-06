require 'spec_helper'
require 'guard/cli'

describe Guard::CLI do
  let(:guard) { Guard }
  let(:ui) { Guard::UI }

  describe '#start' do
    before { Guard.stub(:start) }

    it 'delegates to Guard.start' do
      guard.should_receive(:start)
      subject.start
    end

    context 'when running with Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = 'Gemfile'
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_not_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.start
      end
    end

    context 'when running without Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = nil
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.start
      end
    end
    
    context 'when running with RVM' do
      before do
        @rvm_env = ENV['rvm_ruby_string']
        ENV['rvm_ruby_string'] = nil
      end
      
      after { ENV['rvm_ruby_string'] = @rvm_env }
      
      it 'does not show the Bundler warning' do
        ui.should_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.start
      end
    end

    context 'with an interrupt signal' do
      before do
        guard.should_receive(:start).and_raise(Interrupt)
        guard.stub(:stop)
      end

      it 'exits nicely' do
        guard.should_receive(:stop)
        subject.stub(:abort)

        subject.start
      end

      it 'exits with failure status code' do
        begin
          subject.start
          raise 'Guard did not abort!'
        rescue SystemExit => e
          e.status.should_not eq(0)
        end
      end
    end
  end

  describe '#list' do
    before { ::Guard::DslDescriber.stub(:list) }

    it 'delegates to Guard::DslDescriber.list' do
      ::Guard::DslDescriber.should_receive(:list)
      subject.list
    end

    context 'when running with Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = 'Gemfile'
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_not_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.list
      end
    end

    context 'when running without Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = nil
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.list
      end
    end
  end

  describe '#version' do
    it 'shows the current version' do
      ui.should_not_receive(:info).with(/#{ ::Guard::VERSION }/)
      subject.list
    end

    context 'when running with Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = 'Gemfile'
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_not_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.version
      end
    end

    context 'when running without Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = nil
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.version
      end
    end
  end

  describe '#init' do
    let(:options) { {:bare => false} }

    before do
      subject.stub(:options => options)
      ::Guard.stub(:create_guardfile)
      ::Guard.stub(:initialize_all_templates)
    end

    it 'creates a Guardfile by delegating to Guard.create_guardfile' do
      ::Guard.should_receive(:create_guardfile).with(:abort_on_existence => options[:bare])
      subject.init
    end

    it 'initializes the templates of all installed Guards by delegating to Guard.initialize_all_templates' do
      ::Guard.should_receive(:initialize_all_templates)
      subject.init
    end

    context 'when passed a guard name' do
      it 'initializes the template of the passed Guard by delegating to Guard.initialize_template' do
        ::Guard.should_receive(:initialize_template).with('rspec')
        subject.init 'rspec'
      end
    end

    context 'with the bare option' do
      let(:options) { {:bare => true} }

      it 'Only creates the Guardfile and does not initialize any Guard template' do
        ::Guard.should_receive(:create_guardfile)
        ::Guard.should_not_receive(:initialize_template)
        ::Guard.should_not_receive(:initialize_all_templates)

        subject.init
      end
    end

    context 'when running with Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = 'Gemfile'
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_not_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.init
      end
    end

    context 'when running without Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = nil
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.init
      end
    end
  end

  describe '#show' do
    before { ::Guard::DslDescriber.stub(:show) }

    it 'delegates to Guard::DslDescriber.list' do
      ::Guard::DslDescriber.should_receive(:show)
      subject.show
    end

    context 'when running with Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = 'Gemfile'
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_not_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.show
      end
    end

    context 'when running without Bundler' do
      before do
        @bundler_env = ENV['BUNDLE_GEMFILE']
        ENV['BUNDLE_GEMFILE'] = nil
      end

      after { ENV['BUNDLE_GEMFILE'] = @bundler_env }

      it 'does not show the Bundler warning' do
        ui.should_receive(:warning).with("You are using Guard outside of Bundler, this is dangerous and may not work. Using `bundle exec guard` is safer.")
        subject.show
      end
    end
  end
end
