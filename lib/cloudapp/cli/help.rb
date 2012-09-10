module CloudApp
  class CLI
    class Help
      include Enumerable

      MESSAGES = [ 'Movement:',
                   '  j/k   Move up/down',
                   '  n/p   Next/previous page',
                   '  P     Jump to the first page',
                   '',
                   'Copy Links:',
                   '  c     Copy share link',
                   '  C     Copy embed link',
                   '  d     Copy download link',
                   '  t     Copy thumbnail link',
                   '',
                   'Other:',
                   '  f     Filter drops',
                   '  ?     Show help',
                   '  q     Quit' ],

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
