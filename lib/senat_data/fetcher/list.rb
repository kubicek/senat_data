require 'date'
require 'uri'
require 'net/http'

module SenatData
  module Fetcher
    class List
      def self.path
        "#{SenatData.base_path}/lists"
      end

      def self.last_change
        fpath = File.expand_path("#{path}/*.html")
        puts "Searching #{fpath}"
        last = Dir.glob("#{path}/*.html").sort.last
        last_date = Date.parse(File.basename(last, '.html'))
        [last, last_date]
      end

      def self.normalize(body,date)
        body.gsub(/#{date}/,":RD:").force_encoding("UTF-8")
      end

      def self.fetch(date=nil)
        date ||= last_change[1]
        today = Date.today

        puts "Starting on #{date}"

        loop do
          last, last_date = last_change
          cz_date = date.strftime("%-d.%-m.%Y")
          cz_last_date = last_date.strftime("%-d.%-m.%Y")

          url = "https://www.senat.cz/senatori/index.php?ke_dni=#{cz_date}&O=12&lng=cz&par_2=2"

          uri = URI.parse(url)
          response = Net::HTTP.get_response(uri)

          if normalize(File.read(last),cz_last_date)[0..-2] == normalize(response.body,cz_date)
            puts "#{date} Same as previous"
          else
            File.open("#{path}/#{date}.html","w"){ |f| f.puts response.body }
          end
          date = date.next
          break if date == today
        end
      end
    end
  end
end
