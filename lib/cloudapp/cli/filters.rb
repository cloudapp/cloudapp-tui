require 'forwardable'

module CloudApp
  class CLI
    class Filters
      FILTERS = %w( Active Trash All )

      include Enumerable
      extend  Forwardable
      def_delegator FILTERS, :each
      attr_reader :selection_index

      def initialize(options = {})
        selection_index  = options.fetch(:selection_index, 0)
        @selection_index = constrain_selected_index selection_index
      end

      def first_page()    self end
      def previous_page() self end
      def next_page()     self end

      def selection
        FILTERS[selection_index].downcase
      end

      def previous_selection
        Filters.new selection_index: selection_index - 1
      end

      def next_selection
        Filters.new selection_index: selection_index + 1
      end

    private

      def constrain_selected_index(selection_index)
        [ 0, [ selection_index, 2 ].min ].max
      end
    end
  end
end
