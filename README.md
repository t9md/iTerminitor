iTerminitor
====================
Automate `iTerm` window and tab setup and run several command on each tab automatically.
If you use `Terminal.app`, please use [ terminitor ]( https://github.com/achiu/terminitor ).
This script is for `iTerm` and have very limited feature compared to terminitor.

## Install:

    # require this to manupilate iTerm with applescript ruby bridge
    gem install rb-appscript

    cp iTerminitor.rb dir_in_command_search_path
    chmod +x iTerminitor.rb

    # create ~/.iterminitor directory and sample configuration
    iTerminitor.rb init

## Usage:

    # Start iTerminitor session for CONF
      ./iTerminitor.rb start 'CONF'

    # Show CONF list
      ./iTerminitor.rb list

    # This command create sample CONF for iTerminitor
      ./iTerminitor.rb init

## Stgging: sample.rb

This is sample setting. This DSL is very very similar to [ terminitor ]( https://github.com/achiu/terminitor ). 
Yes, I created this because `iTerm` is not supported by `terminitor`.

    window :name => "tab1", :win_bounds => {:side => 0, :top => 0, :width => 500, :height => 500 } do
      tab :name => "tab2", :session => "Default Session" do
        run "echo 'tab2'"
      end

      tab :name => "tab3", :session => "Default Session" do
        run "echo 'tab3'"
      end
    end

    window :name => "tab1", :win_bounds => {:side => 500, :top => 0, :width => 500, :height => 500 } do
      tab :name => "tab2", :session => "Default Session" do
        run "echo 'tab2'"
      end

      tab :name => "tab3", :session => "Default Session" do
        run "echo 'tab3'"
      end
    end
