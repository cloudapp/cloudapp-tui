require 'cloudapp'
require 'cloudapp/tui/config'
require 'cloudapp/tui/drops'
require 'cloudapp/tui/drops_renderer'
require 'cloudapp/tui/filters'
require 'cloudapp/tui/renderer'
require 'cloudapp/tui/help'
require 'clipboard'
require 'highline'
require 'ffi-ncurses'

module CloudApp
  class TUI
    VERSION = '1.0.0.beta.1'

    include FFI::NCurses

    def log(*args)
      return unless File.exists?('log/curses.txt')
      File.open('log/curses.txt', 'ab+') do |file|
        file.puts args.inspect
      end
    end

    def config
      CloudApp::TUI::Config.new
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
      require_credentials

      initscr
      noecho
      curs_set 0

      load_drops

      loop do
        draw
        select [$stdin], nil, nil
        key $stdin.getc
      end
    ensure
      endwin
    end

    def load_drops(message = 'Loading...')
      @filter ||= 'active'
      status(message) {
        @content = Drops.new account.drops(filter: @filter, limit: 10)
      }
    end

    def draw
      renderer = case @content
                 when CloudApp::TUI::Drops then DropsRenderer
                 else Renderer
                 end

      renderable = renderer.new @content

      @content_window = newwin 20, 0, 0, 0 unless @content_window

      werase   @content_window
      waddstr  @content_window, renderable.render
      wmove    @content_window, renderable.selection_line_number, 0
      wrefresh @content_window
    end

    def create_status
      return if @status_window

      @status_window = newwin 1, 0, 20, 0
      whline @status_window, 0, COLS()
      wnoutrefresh @status_window

      @status = newwin 1, 0, 21, 0
      wnoutrefresh @status
    end

    def status(message)
      create_status
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

    def clear_status
      status ''
    end

    def show_filter_options
      @content = CloudApp::TUI::Filters.new
    end

    def select_filter
      return unless @content.is_a? CloudApp::TUI::Filters
      @filter = @content.selection
      load_drops "Loading #{ filter } drops..."
    end

    def show_help
      @content = CloudApp::TUI::Help.new
    end

    def copy(link)
      return unless @content.is_a? CloudApp::TUI::Drops
      text = @content.selection.send link
      status "Copied: #{ text }"
      Clipboard.copy text
    end

    def trash_drop
      return unless @content.is_a? CloudApp::TUI::Drops
      status('Trashing...') {
        @content = @content.trash_selection
      }
    end

    def recover_drop
      return unless @content.is_a? CloudApp::TUI::Drops
      status('Restoring...') {
        @content = @content.recover_selection
      }
    end

    def toggle_drop_privacy
      return unless @content.is_a? CloudApp::TUI::Drops
      status('Toggling...') {
        @content = @content.toggle_selection_privacy
      }
    end

    def key(char)
      case char
      when ?j then @content = @content.next_selection
      when ?k then @content = @content.previous_selection
      when ?n then status('Loading...') { @content = @content.next_page }
      when ?p then status('Loading...') { @content = @content.previous_page }
      when ?P then status('Loading...') { @content = @content.first_page }

      when ?c then copy(:share_url)
      when ?C then copy(:embed_url)
      when ?d then copy(:download_url)

      when ?# then trash_drop
      when ?r then recover_drop
      when ?! then toggle_drop_privacy

      when ?f then show_filter_options
      when ?\r then select_filter

      when ?? then show_help
      when ?q then exit
      end
    end
  end
end
