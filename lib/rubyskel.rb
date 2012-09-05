require 'active_support/core_ext/hash/keys' # for symbolize_keys!
require 'open3'
require 'optparse'
require 'pp'
require 'yaml'

module Rubyskel
  module ClassMethods
    def run(argv_array)
      merged_options = merge_config_options(parse_options(argv_array))
      pp merged_options if merged_options[:verbose_mode]
      remaining_args = merged_options.delete(:remaining_args)
      exec_command(build_command(merged_options, remaining_args))
    end
    def parse_options(argv_array)
      options = {}
      optparser = OptionParser.new do |opts|
        opts.banner = "Usage: rubyskel.rb [options]"
        opts.separator ""
        opts.separator "Specific options:"
        opts.on('-c', '--config_filename FILENAME',
                "A config file in YAML format."
                ){|c| options[:config_filename] = c}
        opts.on('-h', '--help',"Show usage instructions."){|h| options[:show_help] = true}
        opts.on('-v', '--verbose',"Show verbose output."){|v| options[:verbose_mode] = true}
      end
      optparser.parse!(argv_array)
      options[:remaining_args] = argv_array unless argv_array.empty?
      options
    end
    def do_command(cmd)
      output = nil
      Open3::popen3(*cmd) do |i,o,e,wait_thread|
        output = o.readlines.join
        status = wait_thread.value
        unless status.success?
          raise "Failed with error code #{status.exitstatus}#{e.readlines.join}"
        end
      end
      output
    end
    def exec_command(cmd)
      puts cmd.respond_to?(:join) ? cmd.join(' ') : cmd.to_s
      Kernel.exec(cmd)
    end
    def merge_config_options(options)
      if options[:config_filename]
        puts "Loading config from '#{options[:config_filename]}'" if options[:verbose_mode]
        options.merge(read_config(options[:config_filename]))
      else
        options
      end
    end
    def build_command(options, args)
      raise "args must be an array-like object " unless (args && args.respond_to?(:size) && args.respond_to?(:shift))
      command = args.shift or raise "missing subcommand"
      case command.to_sym
      when :example
        return 'echo "Hello, world!"'
      else
        raise "Undefined subcommand '#{command}'"
      end
    end
    def read_config(yaml_filename)
      YAML::load_file(yaml_filename).symbolize_keys!
    end
  end
  class << self
    include Rubyskel::ClassMethods
  end
end
