require 'nokogiri'

module SenatData
  module Parser
    class List
      def self.path
        "#{SenatData.base_path}/lists"
      end
      def self.parse_file(file)
        html = File.read(file)
        response = Nokogiri::HTML(html)
        response.search("#main table tbody tr").collect{|r|
          cols = r.search("td")
          obvod_id, obvod = cols[0].text.split(" - ",2).collect(&:strip)
          link = cols[1].at("a").attributes['href'].value
          {
            id: link.scan(/par_3=(\d+)/).flatten.first,
            obdobi: link.scan(/&O=(\d\d)&/).flatten.first,
            obvod: obvod,
            obvod_id: obvod_id,
            jmeno: cols[1].text.gsub(/ /," ").strip,
            linkurl: link,
            web: cols[2].text,
            pol_prisl: cols[3].text.strip
          }
        }
      end

      def self.parse
        senators={}
        Dir.glob("#{path}/*.html").sort.each {|file|
          data = parse_file(file)
          date = Date.parse(File.basename(file, '.html'))
          data.each{|person|
            senators[person[:id].to_i]=person
            senators[person[:id].to_i][:linkurl]="https://www.senat.cz/senatori/"+person[:linkurl].gsub(/:RD:/,date.strftime("%-d.%-m.%Y"))
          }
        }
        senators
      end
    end
  end
end
