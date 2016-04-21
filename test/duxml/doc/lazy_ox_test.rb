require File.expand_path(File.dirname(__FILE__) + '/../../../lib/duxml/doc/lazy_ox')
require 'ox'
require 'test/unit'
module Duxml
  class El < ::Ox::Element
    include LazyOx

    def simple_name
      name.split(':').last
    end
  end

  module Root
    def foo
      'hi!'
    end
  end
end

class LazyOxTest < Test::Unit::TestCase
  include Duxml

  def setup
    @x = El.new('root')
  end
  attr_accessor :x

  def test_module_extension
    assert_equal 'hi!', x.foo
  end

  def test_class_array
    #unfiltered
    %w(one two two two).each do |name| x << El.new(name) end
    a = x.two
    assert_equal x.nodes[1], a
    a = x.Two
    assert_equal x.nodes[1], a.first
    a = x.Two
    assert_equal x.nodes[3], a.last

    #filtered by member
    a.first[:attr] = 'val'
    a.last[:attr] = 'value'
    assert_equal [a.first, a.last], x.Two(:attr)

    #filtered by member value
    assert_equal [a.first], x.Two(attr: 'val')

    #selected by block
    assert_equal a.first, x.Two{|n| n[:attr] == 'val'}
  end

  def tear_down
  end
end
