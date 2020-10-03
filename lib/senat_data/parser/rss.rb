require 'rss'

module SenatData
  module Parser
    class RSS
      def self.path
        "#{SenatData.base_path}/rss"
      end
      def self.parse
        Dir.glob("#{path}/*.xml").sort.collect{|filename|
          puts filename
          senator_id = File.basename(filename, '.xml')
          feed = ::RSS::Parser.parse(File.read(filename))
          { title: feed.channel.title,
            items: feed.items.collect { |item|
              obdobi, schuze, cislo, nazev = item.title.split(" - ",4)
              _, _, hlasovani, hlas, vysledek = item.description.match(/(\d+) - (.*) - (.*); Senát odhlasoval: (.*)/).to_a
              {
                senator_id: senator_id.to_i,
                obdobi: obdobi.to_i,
                schuze: schuze.to_i,
                cislo: cislo.to_i,
                nazev: nazev,
                hlasovani: hlasovani,
                hlas: hlas,
                vysledek: vysledek
              }
            }
          }
        }
      end
    end
  end
end
