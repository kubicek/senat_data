require 'JSON'

module SenatData
  class Store
    def self.store(filename,collection,pretty=true)
      collection = collection.values if collection.kind_of?(Hash)
      File.open(filename,"w"){|f|
        f.puts pretty ? JSON.pretty_generate(collection) : collection.to_json
      }
    end

    def self.fetch(filename)
      # @@senators=Hash[JSON.parse(File.read(filename), symbolize_names: true).collect{|h| [h[:id],h]}]
      JSON.parse(File.read(filename), symbolize_names: true)
    end

    def self.fetch_hash(filename, key=:id)
      Hash[fetch(filename).collect{|h| [h[key],h]}]
    end

  end
end
