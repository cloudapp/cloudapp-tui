require 'forwardable'

module CloudApp
  class CLI
    class Drops
      include Enumerable
      extend  Forwardable
      def_delegator :@drops, :each
      attr_reader   :selection_index

      def initialize(drops, options = {})
        @drops = drops
        @selection_index = constrain_selected_index options[:selection_index] || 0
      end

      def next_page
        return self unless @drops.has_link?('next')
        Drops.new @drops.follow('next')
      end

      def previous_page
        return self unless @drops.has_link?('previous')
        Drops.new @drops.follow('previous')
      end

      def first_page
        return self unless @drops.has_link?('first')
        Drops.new @drops.follow('first')
      end

      def next_selection
        Drops.new @drops, selection_index: selection_index + 1
      end

      def previous_selection
        Drops.new @drops, selection_index: selection_index - 1
      end

      def selected_line_number
        @selection_index * 2
      end

      def selection
        @drops[@selection_index]
      end

    private

      def constrain_selected_index(selection_index)
        [ 0, [ selection_index, @drops.count - 1 ].min ].max
      end
    end
  end
end
