require File.expand_path(File.dirname(__FILE__) + "/helper_for_tests")

class TestRubyskel < Test::Unit::TestCase
  context 'Rubyskel' do
    context '.parse_options' do
      should 'recognize the -c param' do
        expected = {:config_filename => 'blah'}
        assert_equal expected, Rubyskel.parse_options(%w{-c blah})
      end
      should 'recognize the --config_filename param' do
        expected = {:config_filename => 'blah'}
        assert_equal expected, Rubyskel.parse_options(%w{--config_filename blah})
      end
      should 'consume switches from the passed array' do
        args = %w{-c foo bar}
        Rubyskel.parse_options args
        assert_equal args, %w{bar}
      end
      should 'handle the help command specially' do
        assert_equal({:show_help => true}, Rubyskel.parse_options(%w{-h}))
      end
    end
    context '.run' do
      should 'load options and config, then call build_command and run_command' do
        fake_args = %w{-c foo bar}
        fake_parsed_options = {:config_filename => 'foo', :remaining_args => ['bar']}
        fake_config_contents = {:config_file_var1 => 'whatever'}
        fake_merged_options = fake_config_contents.merge(fake_parsed_options)
        fake_cmd = "echo 'blah'"
        Rubyskel.expects(:parse_options).with(fake_args).returns(fake_parsed_options)
        Rubyskel.expects(:merge_config_options).with(fake_parsed_options).returns(fake_parsed_options)
        Rubyskel.expects(:build_command).with(fake_parsed_options, ['bar']).returns(fake_cmd)
        Rubyskel.expects(:exec_command).with(fake_cmd)
        Rubyskel.run(fake_args)
      end
    end
    context '.exec_command' do
      should 'delegate to Kernel.exec' do
        fake_cmd = %w{echo foo}
        Rubyskel.expects(:puts).with("echo foo")
        Kernel.expects(:exec).with(fake_cmd)
        Rubyskel.exec_command(fake_cmd)
      end
    end
    context '.do_command' do
      should 'run the specified command' do
        assert_equal('Hi!', Rubyskel.do_command(['echo','-n',"Hi!"]))
      end
      should 'raise an exception if the command fails' do
        assert_raise(RuntimeError){Rubyskel.do_command(['sh','-c','exit 1'])}
      end
    end
    context '.merge_config_options' do
      should 'merge the config file contents into the options argument' do
        fake_parsed_options = {:config_filename => 'foo'}
        fake_config_contents = {:config_file_var1 => 'whatever'}
        Rubyskel.expects(:read_config).with('foo').returns(fake_config_contents)
        merged = Rubyskel.merge_config_options(fake_parsed_options)
        expected_merged_options = fake_config_contents.merge(fake_parsed_options)
        assert_equal(merged, expected_merged_options)
      end
      should 'be a no-op if the :config_filename option is missing' do
        assert_nothing_raised(){Rubyskel.merge_config_options({})}
      end
    end
    context '.read_config' do
      should 'read a YAML file into a hash' do
        filename = File.expand_path(File.dirname(__FILE__) + "/data/test_config.yml")
        expected = {:port => 54321, :debug_port => 30201}
        assert_equal expected, Rubyskel.read_config(filename)
      end
    end
    context '.build_command' do
      context 'with example' do
        should 'return a command line that echoes Hello world' do
          expected = 'echo "Hello, world!"'
          assert_equal expected, Rubyskel.build_command({}, ['example'])
        end
      end
    end
  end
end
