module CloudApp
  class CLI
    class Drops
      include Enumerable
      attr_reader :selection_index

      def initialize(drops, options = {})
        @drops = drops
        @selection_index = constrain_selected_index options[:selection_index] || 0
      end

      def each(&block) @drops.each(&block)      end
      def selection()  @drops[@selection_index] end

      def first_page
        return self unless @drops.has_link?('first')
        Drops.new @drops.follow('first')
      end

      def previous_page
        return self unless @drops.has_link?('previous')
        Drops.new @drops.follow('previous')
      end

      def next_page
        return self unless @drops.has_link?('next')
        Drops.new @drops.follow('next')
      end

      def previous_selection
        Drops.new @drops, selection_index: selection_index - 1
      end

      def next_selection
        Drops.new @drops, selection_index: selection_index + 1
      end

      def trash_selection
        selection.trash
        Drops.new @drops.follow('self'), selection_index: selection_index
      end

      def recover_selection
        selection.recover
        Drops.new @drops.follow('self'), selection_index: selection_index
      end

      def toggle_selection_privacy
        selection.toggle_privacy
        Drops.new @drops.follow('self'), selection_index: selection_index
      end

    private

      def constrain_selected_index(selection_index)
        [ 0, [ selection_index, @drops.count - 1 ].min ].max
      end
    end
  end
end
