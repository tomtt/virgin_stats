module VirginStats
  class DisplayTable
    @@format = "%17s | %2s | %9s | %12s | %16s || %2s | %9s | %12s | %17s |"
    def self.get_data
      Dir.glob(File.join(VirginStats.data_dir, "*")).map { |f| File.read(f) }
    end

    def self.display
      puts "%17s | %-48s || %-49s |" % [" ", "Up", "Down"]
      puts @@format % ["Timestamp",
                       "ID",
                       "Power",
                       "Frequency",
                       "Symbol Rate",
                       "ID",
                       "Power",
                       "Frequency",
                       "Bit Rate"]
      get_data.each { |d| puts format_data_point(d) }
    end

    def self.format_data_point(data_point)
      data = eval(data_point)
      time = Time.parse(data[:timestamp]).strftime("%Y-%m-%d %H:%M")
      @@format % [time,
                  data[:upstream]["Channel ID"],
                  data[:upstream]["Power Level"],
                  data[:upstream]["Upstream Frequency"],
                  data[:upstream]["Symbol Rate"],
                  data[:downstream]["Channel ID"],
                  data[:downstream]["Power Level"],
                  data[:downstream]["Downstream Frequency"],
                  data[:downstream]["Bit Rate"]]
    end
  end
end
