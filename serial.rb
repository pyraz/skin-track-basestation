require 'serialport'
require 'active_record'

port_str = "/dev/ttyUSB0"
baud = 57600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

ActiveRecord::Base.establish_connection({:adapter => 'sqlite3', :database => 'db.sqlite'})

class Test < ActiveRecord::Base
end

puts "DB set up...connecting Serial"

sp = SerialPort.new(port_str, baud, data_bits, stop_bits, parity)

@value = 0

while true do
  char = sp.getc
  if char == '\r' || char == '\n'
    if @value > 0
      puts "Value: #{value}"
      test = Test.new
      test.value = char.to_i
      test.save
      @value = 0
    end
  else
    @value += char.to_i
  end
end
