require 'nokogiri'

module SenatData
  module Parser
    class Detail
      def self.path
        "#{SenatData.base_path}/details"
      end
      def self.parse_file(file)
        id=File.basename(file, '.html').to_i
        html = File.read(file)
        doc = Nokogiri::HTML(html)
        mandat_od, mandat_do = doc.at('td:contains("Mandát")').next.text.split("   - ",2)
        volebni_strana, _ = doc.at('td:contains("Zvolen za")').next.text.split(" v roce ",2)
        node = doc.at('td:contains("WWW")')
        web = (node ? node.next.text : nil)
        node = doc.at('td:contains("E-mail")')
        email = (node ? node.next.text : nil)
        {
          id: id,
          cele_jmeno: doc.at('.mainCol header h1').text.split(" (aktuální k ",2).first.strip,
          obvod_id: doc.at('td:contains("Obvod")').next.text[3..-1],
          mandat_od: Date.parse(mandat_od),
          mandat_do: Date.parse(mandat_do),
          volebni_strana: volebni_strana,
          web: web,
          email: email,
          imageurl: ["https://www.senat.cz/",html.scan(/images\/senatori\/.*295.jpg/).first].join
        }
      end

      def self.parse
        Hash[
          Dir.glob("#{path}/*.html").collect {|file|
            id = File.basename(file, '.html').to_i
            [id,parse_file(file)]
          }
        ]
      end
    end
  end
end
