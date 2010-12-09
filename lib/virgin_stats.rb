require "virgin_stats/scraper"
require "virgin_stats/display_table"

if Gem.available?("ruby-debug")
  require "ruby-debug"
end

module VirginStats
  def self.data_dir
    @@data_dir ||= File.expand_path(File.join(File.dirname(__FILE__), '..', "data"))
  end
end
