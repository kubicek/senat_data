require 'senat_data/version'

require 'senat_data/fetcher'
require 'senat_data/parser'
require 'senat_data/reducer'
require 'senat_data/store'

module SenatData
  class Error < StandardError; end

  def self.base_path
    @@base_path
  end

  def self.base_path=(value)
    @@base_path=value
  end
end
