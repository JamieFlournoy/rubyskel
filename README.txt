1.0 Spec:
- command and subcommand syntax
- ruby with simple initial impl
- no support for non-screen term types, just a command builder

run app:
  rvm use ruby-1.9.3-p194@rubyskel
  ./rubyskel -c my_rubyskel_config.conf SOME_COMMAND

run tests:
  rvm use ruby-1.9.3-p194@rubyskel
  ruby -I.:lib:test -rubygems ./test/test_*.rb
or just
  autotest
