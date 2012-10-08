module CloudApp
  class TUI
    class DropsRenderer
      def initialize(drops)
        @drops = drops
      end

      def render
        @drops.map {|drop|
          if drop.trashed? || !drop.private?
            mark = ''
            mark << "\u2716" if  drop.trashed?
            mark << '!'      if !drop.private?
            mark << ' '
          end
          [ "#{ mark }#{ drop.name }",
            "  #{ pretty_date(drop.created) }, #{ drop.views }"
          ].join("\n")
        }.join("\n")
      end

      def selection_line_number
        @drops.selection_index * 2
      end

    private

      def pretty_date(date)
        diff = (Time.now - date.to_time).to_i
        case diff
          when 0               then 'just now'
          when 1               then 'a second ago'
          when 2..59           then diff.to_s+' seconds ago'
          when 60..119         then 'a minute ago' #120 = 2 minutes
          when 120..3540       then (diff/60).to_i.to_s+' minutes ago'
          when 3541..7100      then 'an hour ago' # 3600 = 1 hour
          when 7101..82800     then ((diff+99)/3600).to_i.to_s+' hours ago'
          when 82801..172000   then 'a day ago' # 86400 = 1 day
          when 172001..518400  then ((diff+800)/(60*60*24)).to_i.to_s+' days ago'
          when 518400..1036800 then 'a week ago'
          else ((diff+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
        end
      end
    end
  end
end
