HEX = {
  '0' => '0000',
  '1' => '0001',
  '2' => '0010',
  '3' => '0011',
  '4' => '0100',
  '5' => '0101',
  '6' => '0110',
  '7' => '0111',
  '8' => '1000',
  '9' => '1001',
  'A' => '1010',
  'B' => '1011',
  'C' => '1100',
  'D' => '1101',
  'E' => '1110',
  'F' => '1111'
}
input = File.read('input.txt').chars.map { |hexdigit| HEX[hexdigit] }.join

def decode_literal(body)
  decoded = ''
  length = 0
  while body[0] == '1'
    decoded += body[1..4]
    body = body[5..]
    length += 5
  end
  decoded += body[1..4]
  length += 5
  { value: decoded.to_i(2), length: length }
end

def decode_operator(body)
  ltype = body[0] == '0' ? :length : :packets
  length = 1
  value = if ltype == :length
            length += 15
            body[1..15].to_i(2)
          else
            length += 11
            body[1..11].to_i(2)
          end

  children = []
  if ltype == :length
    subbody = body[16..(16 + value - 1)]
    while subbody.length.positive?
      subpacket = decode(subbody)
      length += subpacket[:length]
      children << subpacket
      subbody = subbody[(subpacket[:length])..]
    end
  else
    subbody = body[12..]
    value.times.each do
      subpacket = decode(subbody)
      length += subpacket[:length]
      children << subpacket
      subbody = subbody[(subpacket[:length])..]
    end
  end

  { ltype: ltype, value: value, length: length, children: children }
end

def decode(packet)
  version = packet[0..2].to_i(2)
  ttype = packet[3..5].to_i(2)
  body = packet[6..]

  body = if ttype == 4
           decode_literal(body)
         else
           decode_operator(body)
         end
  body[:length] += 6
  { version: version, ttype: ttype }.merge(body)
end

def sum_version(ast)
  base = ast[:version]
  return base if ast[:ttype] == 4

  ast[:children].map { |child| sum_version(child) }.sum + base
end

def evaluate(ast)
  return ast[:value] if ast[:ttype] == 4

  children = ast[:children].map { |child| evaluate(child) }

  case ast[:ttype]
  when 0
    children.sum
  when 1
    children.reduce(:*)
  when 2
    children.min
  when 3
    children.max
  when 5
    children[0] > children[1] ? 1 : 0
  when 6
    children[0] < children[1] ? 1 : 0
  when 7
    children[0] == children[1] ? 1 : 0
  end
end

ast = decode(input)
puts sum_version(ast)
puts evaluate(ast)
