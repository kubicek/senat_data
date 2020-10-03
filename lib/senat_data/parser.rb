require 'senat_data/parser/detail'
require 'senat_data/parser/list'
require 'senat_data/parser/rss'

module SenatData
  module Parser
    def self.parse_all
      puts Parser::List.parse
      Parser::RSS.parse
      Parser::Detail.parse
    end
  end
end
