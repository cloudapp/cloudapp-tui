module CloudApp
  class TUI
    class Renderer
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
