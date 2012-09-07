module CloudApp
  module CLI
    class DropsRenderer
      def initialize(drops)
        @drops = drops
      end

      def render
        @drops.map(&:name).join("\n")
      end
    end
  end
end
