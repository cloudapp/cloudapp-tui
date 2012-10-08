module CloudApp
  class TUI
    class Help
      include Enumerable

      MESSAGES = [ 'Commands:',
                   '  j,k    Move selection up/down',
                   '  n,p,P  Go to the next/previous/first page',
                   '',
                   "  c,C,d  Copy a drop's share/embed/download link",
                   '  #,r    Trash/recover a drop',
                   '  !      Toggle drop privacy',
                   '  f      Filter drops',
                   '',
                   '  ?      Show help',
                   '  q      Quit',
                   '',
                   'Legend:',
                   "  !    Public",
                   "  \u2716    Trashed" ]

      def each(&block)         MESSAGES.each(&block) end
      def first_page()         self end
      def previous_page()      self end
      def next_page()          self end
      def previous_selection() self end
      def next_selection()     self end
      def selection_index()    0    end
      def selection() end
    end
  end
end
