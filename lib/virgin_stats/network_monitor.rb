module VirginStats
  class NetworkMonitor
    @@ping_count = 1
    @@server = "www.google.com"
    @@sleep_duration = 10

    def self.ping_succeeds?
      `ping -q -c #{@@ping_count} #{@@server} 2> /dev/null`
      $?.exitstatus == 0
    end

    def initialize
      @log_file_name = VirginStats.network_monitor_log_file_name
    end

    def start
      log("Starting monitoring")
      @last_network_status_online = NetworkMonitor::ping_succeeds?
      log("Initial status: %s" % (@last_network_status_online ? "online" : "OFFline"))
      while(1)
        sleep(@@sleep_duration)
        current_net_status_online = NetworkMonitor::ping_succeeds?
        if current_net_status_online != @last_network_status_online
          log("Network status changed to: %s" % (current_net_status_online ? "online" : "OFFline"))
          @last_network_status_online = current_net_status_online
        end
      end
    end

    def formatted_current_time
      Time.now.strftime("%Y-%m-%d %H:%M:%S %z")
    end

    def log(msg)
      File.open(@log_file_name, "a") do |f|
        f.puts("[%s] %s" % [formatted_current_time, msg])
      end
    end
  end
end
