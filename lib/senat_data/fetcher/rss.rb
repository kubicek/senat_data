module SenatData
  module Fetcher
    class RSS
      def self.path
        "#{SenatData.base_path}/rss"
      end
      def self.fetch(senators)
        senators.each{|i,s|
          File.open("#{path}/#{s[:id]}.xml","w"){|f|
            response = Net::HTTP.get_response(URI.parse(
              "https://www.senat.cz/senatori/hlasovani_rss.php?pid=#{s[:id]}"
            ))
            f.puts response.body
          }
        }
      end
    end
  end
end
