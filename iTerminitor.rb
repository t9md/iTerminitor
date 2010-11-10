#!/usr/bin/env ruby

require 'rubygems'
require 'appscript'
include Appscript

class ITerminitor
  @@setting_dir = File.expand_path('~/.iterminitor')

  def self.start(setting)
    iTerm = self.new
    setting_path = @@setting_dir + "/#{setting}"
    unless File.exist? setting_path
      warn "file #{setting_path} not found!!"
      return 1
    end
    iTerm.instance_eval(File.read(setting_path))
  end

  def self.list
    puts Dir.glob(@@setting_dir + "/*")
  end

  def self.init
    if File.exist?(@@setting_dir) and File.directory?(@@setting_dir)
      return
    else
      Dir.mkdir(@@setting_dir)
      File.open(@@setting_dir + "/sample.rb", 'w') do |f|
        f.puts <<EOS
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
EOS
      end
    end
  end

  def initialize
    @term = app('iTerm')
    @shell = ENV['SHELL']
  end

  def window(opt = {}, &blk)
    app('System Events').application_processes['iTerm.app'].keystroke('n', :using => :command_down)

    if opt[:win_bounds]
      puts "hogehoge"
      window_bounds(opt[:win_bounds])
    end
    self.instance_eval(&blk)
  end

  def tab(opt, &blk)
    session_name = opt[:session] || "Default Session"
    @term.current_terminal.launch_(:session => session_name)
    if opt[:name]
      @term.current_terminal.current_session.name.set(opt[:name])
    end
    self.instance_eval(&blk)
  end

  def run(cmd)
    @term.current_terminal.current_session.write(:text => cmd)
  end


  def window_bounds(opt)
    s = opt[:side]
    t = opt[:top]
    w = s + opt[:width]
    h = t + opt[:height]
    app("iTerm").windows.first.bounds.set([s, t, w, h])
    # window_bounds([0, 0, 1900, 1200])
  end

  def select_session(name)
    iTerm = app('iTerm')
    1.upto(iTerm.terminals.sessions.count) do |num|
      if iTerm.current_terminal.sessions[num].name.get == name
        iTerm.current_terminal.sessions[num].select
        break
      end
    end
  end

  def self.help
    puts
    puts "### Usage:"
    puts "# Start iTerminitor session for CONF"
    puts "  #{$PROGRAM_NAME} start 'CONF'"
    puts
    puts "# Show CONF list"
    puts "  #{$PROGRAM_NAME} list"
    puts
    puts "# This command create sample CONF for iTerminitor"
    puts "  #{$PROGRAM_NAME} init"
    puts
  end
end

if __FILE__ == $PROGRAM_NAME
  cmd = ARGV.shift
  case cmd
  when 'start'
    config = ARGV.shift
    unless config
      ITerminitor.help
      exit 1
    end
    ITerminitor.start config
  when 'list'
    ITerminitor.list
  when 'init'
    ITerminitor.init
  else
    ITerminitor.help
  end
end
