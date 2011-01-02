module VirginStats
  class DisplayTable
    @@format = "%17s | %2s | %9s | %12s | %16s | %6s || %2s | %10s | %12s | %17s | %8s | %6s | %s"
    def self.get_data
      Dir.glob(File.join(VirginStats.data_dir, "*")).map { |f| File.read(f) }
    end

    def self.display
      puts "%17s | %-57s || %-58s |" % [" ", "Up", "Down"]
      puts @@format % ["Timestamp",
                       "ID",
                       "Power",
                       "Frequency",
                       "Symbol Rate",
                       "Mod",
                       "ID",
                       "Power",
                       "Frequency",
                       "Bit Rate",
                       "S2N",
                       "Mod",
                       ""]
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
                  data[:upstream]["Modulation"],
                  data[:downstream]["Channel ID"],
                  data[:downstream]["Power Level"],
                  data[:downstream]["Downstream Frequency"],
                  data[:downstream]["Bit Rate"],
                  data[:downstream]["Signal to Noise Ratio"],
                  data[:downstream]["Modulation"],
                  data[:comment]]
    end
  end
end
