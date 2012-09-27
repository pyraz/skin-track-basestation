require 'serialport'

port_str = "/dev/ttyUSB0"
baud = 57600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud, data_bits, stop_bits, parity)

while true do
  printf "%c", sp.getc
end