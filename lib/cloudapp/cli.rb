require 'cloudapp'
require 'cloudapp/cli/config'
require 'cloudapp/cli/drops'
require 'cloudapp/cli/drops_renderer'
require 'clipboard'
require 'highline'
require 'ffi-ncurses'

module CloudApp
  class CLI
    VERSION = '1.0.0.beta.6'

    include FFI::NCurses

    def log(*args)
      return unless File.exists?('log/curses.txt')
      File.open('log/curses.txt', 'ab+') do |file|
        file.puts args.inspect
      end
    end

    def config
      CloudApp::CLI::Config.new
    end

    def account
      CloudApp::Service.using_token config.token
    end

    def require_credentials
      return unless config.token.nil?

      $stdout.puts 'Sign into your CloudApp account.'

      email        = HighLine.new.ask('Email: ')
      password     = HighLine.new.ask('Password: ') {|q| q.echo = false }
      config.token = CloudApp::Service.token_for_account email, password
    end


    def self.start
      new.start
    end

    def start
      initscr
      noecho
      curs_set 0

      move_status
      status 'Loading...' do
        @drops = Drops.new account.drops
      end

      loop do
        draw
        select [$stdin], nil, nil
        key $stdin.getc
      end
    ensure
      endwin
    end

    def copy(text)
      status "Copied: #{ text }"
      Clipboard.copy text
    end

    def draw
      content = DropsRenderer.new(@drops).render

      unless @drops_window
        @drops_window = newwin content.lines.count, 0, 0, 0
      end

      move_status content.lines.count

      werase  @drops_window
      waddstr @drops_window, content
      wmove   @drops_window, @drops.selected_index, 0
      wnoutrefresh @drops_window
      doupdate
    end

    def move_status(lines = 20)
      unless @status_window
        @status_window = newwin 1, 0, 0, 0
        whline @status_window, 0, COLS()

        @status = newwin 1, 0, 0, 0
      end

      mvwin @status_window, lines, 0
      mvwin @status, lines + 1, 0
      wnoutrefresh @status_window
      wnoutrefresh @status
    end

    def status(message)
      werase  @status
      waddstr @status, message
      wnoutrefresh @status

      if block_given?
        doupdate
        response = yield
        clear_status
        response
      end
    end

    def show_filter_options
      content = <<-FILTER
Active
Trash
All
FILTER

      status 'filter'
      werase  @drops_window
      waddstr @drops_window, content

      selected = 0
      loop do
        wmove    @drops_window, selected, 0
        wrefresh @drops_window

        select [$stdin], nil, nil
        case $stdin.getc
        when ?\r then break
        when ?j  then selected += 1
        when ?k  then selected -= 1
        end

        selected = [ 0, [ selected, 2 ].min ].max
      end

      filter = %w( active trash all )[selected]
      status("Loading #{ filter } drops...") {
        @drops = Drops.new account.drops(filter: filter)
      }
    end

    def clear_status
      status ''
    end

    def key(char)
      case char
      when ?j then status('Loading...') { @drops = @drops.select_next }
      when ?k then status('Loading...') { @drops = @drops.select_previous }
      when ?n then status('Loading...') { @drops = @drops.next_page }
      when ?p then status('Loading...') { @drops = @drops.previous_page }
      when ?P then status('Loading...') { @drops = @drops.first_page }

      when ?c then copy @drops.selection.share_url
      when ?C then copy @drops.selection.embed_url
      when ?D then copy @drops.selection.download_url
      when ?t then copy @drops.selection.thumbnail_url

      when ?f then show_filter_options
      when ?? then status 'Help not implemented.'

      when ?q then raise SystemExit
      end
    end
  end
end
