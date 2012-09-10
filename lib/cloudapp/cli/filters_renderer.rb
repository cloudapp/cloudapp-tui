module CloudApp
  class CLI
    class FiltersRenderer
      def initialize(filters)
        @filters = filters
      end

      def render
        @filters.to_a.join("\n")
      end

      def selection_line_number
        @filters.selection_index
      end
    end
  end
end
