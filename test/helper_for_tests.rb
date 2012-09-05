if defined?(TEST_HELPER)
  raise "HelperForTests has been re-required, check your require syntax and make sure you're using File.expand_path to canonicalize paths."
else
  TEST_HELPER = true

  $LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..'))

  require 'lib/rubyskel'
  require 'shoulda'
  require 'mocha'
#  require 'webmock/test_unit'

#  module DirGlobbing
#    def files_in_dir(dir_path, pattern)
#      Dir.chdir(dir_path){ Dir.glob(pattern) }
#    end
#  end

#  LOG_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', 'log'))
#  module LogFilePath
#    def test_log_path
#      File.join(LOG_DIR, 'test.log')
#    end
#  end
 
#  module FileAssertions
#    def assert_file_exists(path)
#      assert File.exists?(path), "File does not exist: #{path}"
#    end
#
#    def assert_file_has_contents(path, expected_contents)
#      assert_file_exists(path)
#      actual_contents = File.open(path){|f| f.read}
#      assert_equal expected_contents, actual_contents, "File exists with wrong contents: #{path}"
#    end
#  end

#  module ObjectMother
#    def make_example(config = nil)
#      Rubyskel::Example.new(config)
#    end
#  end


#  class Test::Unit::TestCase
#    include DirGlobbing
#    include WebMock
#    include FileAssertions
#    include ObjectMother
#  end

end
