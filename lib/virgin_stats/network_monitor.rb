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
      @offline_start_time = Time.now
      @loop_count = 0
      log("Initial status: %s" % (@last_network_status_online ? "online" : "OFFline"))
      while(1)
        @loop_count += 1
        sleep(@@sleep_duration)
        current_net_status_online = NetworkMonitor::ping_succeeds?
        if current_net_status_online != @last_network_status_online
          if current_net_status_online
            log("Network status changed to: online (outage for %d seconds)" % (Time.now - @offline_start_time))
          else
            log("Network status changed to: OFFline")
            @offline_start_time = Time.now
          end
          @last_network_status_online = current_net_status_online
        end

        if @loop_count % 1000 == 0
          log("Monitoring in progress (%d pings performed)" % @loop_count)
        end
      end
    end

    def stop
      log("Stopped monitoring")
      exit(0)
    end

    def formatted_current_time
      Time.now.strftime("%Y-%m-%d %H:%M:%S %z")
    end

    def log(msg)
      File.open(@log_file_name, "a") do |f|
        s = "[%s] %s" % [formatted_current_time, msg]
        f.puts(s)
        puts(s)
      end
    end
  end
end
