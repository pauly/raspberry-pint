class OneWire

  @deviceRoot = nil
  @logFile = nil

  def initialize options = { }
    `sudo modprobe w1-gpio`
    `sudo modprobe w1-gpio`
    @deviceRoot = '/sys/bus/w1/devices/'
    @logFile = '/tmp/temperature.log'
    if options[ :logDir ]
      @logFile = options[ :logDir ] + '/temperature.log'
    end
  end

  def read
    data = { }
    puts 'read, ' + @deviceRoot
    Dir[ @deviceRoot + '*-*' ].each_with_index do | path, i |
      id = path.sub @deviceRoot, ''
      file_contents = File.read( path + '/w1_slave' )
      data[ id ] = file_contents.split( 't=' ).last
      data[ id ] = data[ id ].to_f / 1000
    end
    puts 'so data is ' + data.inspect
    data
  end

  def writeLog
    logEntry = [ Time.now.to_i ]
    self.read.each do | reading |
      logEntry.push reading.last # the temperature
    end
    open( @logFile, 'a' ) do | f |
      f.puts logEntry.join( "\t" )
    end
  end

  def readLog
    data = [ [ 'time' ] ]
    self.read.each { | reading |
      data[0].push reading.first # the id
    }
    puts 'so far graph data is ' + data.inspect
    open( @logFile, 'r' ) do | f |
      f.each_line do | line |
	data.push line.strip.split( "\t" )
      end
    end
    puts 'now graph data is ' + data.inspect
    data
  end

end
