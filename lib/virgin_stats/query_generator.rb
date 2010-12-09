module VirginStats
  class QueryGenerator
    def self.from_data_hash(pre_data)
      data = {}
      pre_data[:downstream].each do |key, value|
        data[map_key(:downstream, key)] = map_value(:downstream, value)
      end
      pre_data[:upstream].each do |key, value|
        data[map_key(:upstream, key)] = map_value(:upstream, value)
      end
      data["created_at"] = Time.now
      keys = data.keys.sort
      keys_string = (keys.map { |key| "`#{key}`" } + ["`created_at`"]).join(", ")
      values_string = (keys.map { |key| "`#{data[key]}`"} + ["NOW()"]).join(", ")
      "INSERT INTO `virgin_data_samples` (%s) VALUES (%s)" % [keys_string, values_string]
    end

    def self.map_key(stream, key)
      res = key.downcase.tr(' ', '_')
      unless res.include?(stream.to_s)
        res = stream.to_s + "_" + res
      end
      res
    end

    def self.map_value(stream, value)
      value
    end
  end
end
