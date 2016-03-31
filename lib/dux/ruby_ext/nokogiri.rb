require 'nokogiri'
require_relative 'object'
require_relative 'string'

class Nokogiri::XML::Document
  # exists purely to clean up generated output
  def remove_empty_lines!
    self.xpath("//text()").each do |text|
      text.content = text.content.gsub(/\n(\s*\n)+/,"\n")
    end
    self
  end
end

# creates instance of Nokogiri::XML::Element using args as starting values.
# first argument must be provided and be a String for name of the desired element.
# second argument can be either be: if a Hash, then attributes and their values
#                                   if not, then content String
# if there is a third argument, then the second must be the attribute Hash, and third the content String
def element(*args)
  raise ArgumentError unless args.first.identifier?
  name = args.first
  attrs = Hash.new
  content = ''
  if args.size == 3
    attrs &&= args[1]
    content &&= args[2]
  elsif args.last.is_a?(Hash)
    attrs = args.last
  elsif args.size == 2
    raise ArgumentError unless args.last.respond_to?(:to_s)
    content = args.last
  end
  e = "<#{name}>#{content}</#{name}>".xml
  attrs.each do |attr, val|
    e[attr]=val
  end unless attrs.nil?
  e
end