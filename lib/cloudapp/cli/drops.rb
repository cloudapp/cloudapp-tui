require 'forwardable'

module CloudApp
  class CLI
    class Drops
      include Enumerable
      extend  Forwardable
      def_delegator :@drops, :each
      attr_reader   :selected_index

      def initialize(drops, options = {})
        @drops = drops
        @selected_index = constrain_selected_index options[:selected_index] || 0
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

      def select_next
        Drops.new @drops, selected_index: selected_index + 1
      end

      def select_previous
        Drops.new @drops, selected_index: selected_index - 1
      end

      def selection
        @drops[@selected_index]
      end

    private

      def constrain_selected_index(selected_index)
        [ 0, [ selected_index, @drops.count - 1 ].min ].max
      end
    end
  end
end
