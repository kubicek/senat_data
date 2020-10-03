module SenatData
  module Fetcher
    class Detail
      def self.path
        "#{SenatData.base_path}/details"
      end
      def self.fetch(senators)
        senators.each{|i,s|
          File.open("#{path}/#{s[:id]}.html","w"){|f|
            response = Net::HTTP.get_response(URI.parse(s[:linkurl]))
            f.puts response.body
          }
        }
      end
    end
  end
end
