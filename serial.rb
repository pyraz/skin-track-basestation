require 'serialport'
require 'active_record'

if ARGV.size != 1
  abort("Invalid argument, please provide port")
end

port_str = ARGV[0]
baud = 57600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

ActiveRecord::Base.establish_connection({:adapter => 'sqlite3',
    :database => 'db.sqlite'})

class SkinTrackRecord < ActiveRecord::Base
end

puts "DB set up...connecting Serial"

sp = SerialPort.new(port_str, baud, data_bits, stop_bits, parity)

while true do
  string = sp.gets
  string.encode!('UTF-8', 'UTF-8', :invalid => :replace)
  match = string.match(/Record:\s*(-*\d,\s*\d)/)
  if match
    $stdout.puts "Record found"
    record = match[1].split(",").map {|r| r.to_i}
    $stdout.puts "Direction: #{record[0]}, Beacon: #{record[1]}"
    if record[0] == 0
      direction = "enter"
    elsif record[0] > 0
      direction = "exit"
    else
      direction = "unknown"
    end

    beacon = record[1] > 0 ? true : false

    SkinTrackRecord.create(:direction => direction, :beacon => beacon)
  else
    $stdout.puts string
  end
end
