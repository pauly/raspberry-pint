#!/usr/bin/ruby
require_relative 'OneWire.rb'
wire = OneWire.new :logDir => '/home/pi/'

wire.writeLog
graphData = wire.readLog

data = graphData.inspect.to_s.gsub /"([\d.]+)"/, '\1'
data = data.gsub /\[([\d]+)/, '[new Date(\1000)'
html = <<-eos
      <div id="curveChart" style="width: 800px; height: 600px"></div>
      <p>Right now 28-0004784c24ff (the blue line) is a temperature probe resting on top of the brew, and 28-00044a7b9fff (the red line) is under the brewing bucket though now raised from the floor.</p>
      <p>Hesitant to put the probe in the beer yet, though it's waterproof, think I need a well or something to keep it sterile.</p>
      <script type="text/javascript" src="https://www.google.com/jsapi?autoload={ 'modules':[{ 'name':'visualization', 'version':'1', 'packages':['corechart'] }] }"></script>
      <script type="text/javascript">
        var drawChart = function ( ) {
          var data = google.visualization.arrayToDataTable( #{data} );
          var options = {
            title: 'Temperature gauges',
            curveType: 'function',
            legend: { position: 'bottom' }
          };
          var chart = new google.visualization.LineChart( document.getElementById( 'curveChart' ));
          chart.draw( data, options );
        };
        google.setOnLoadCallback( drawChart );
      </script>
eos
html = html.strip.gsub /[\n\r]/, ' '
puts html.strip
