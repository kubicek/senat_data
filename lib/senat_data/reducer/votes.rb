module SenatData
  module Reducer
    class Votes
      def self.reduce(votes)
        votes.collect{|i| i[:items]}.flatten.group_by{|i|
          [i[:obdobi], i[:schuze], i[:cislo]]
        }.collect{|k,v|
          {
            obdobi: v.first[:obdobi],
            schuze: v.first[:schuze],
            cislo: v.first[:cislo],
            nazev: v.first[:nazev],
            hlasovani: v.first[:hlasovani],
            vysledek: v.first[:vysledek],
            hlasy: Hash[v.group_by{|i|
              i[:hlas]}.collect{|k,v| [k,v.collect{|h| h[:senator_id]}]
            }]
          }
        }
      end
    end
  end
end
