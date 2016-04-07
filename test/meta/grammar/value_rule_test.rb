require File.expand_path(File.dirname(__FILE__) + '/../../../lib/duxml/meta/grammar/rule/value_rule')
require 'minitest/autorun'

class ValueRuleTest < MiniTest::Test
  def setup
  end

  def test_init_value_rule
    rule = Duxml::ValueRule.new 'legal_parent', 'attr_name', 'statement | of | rule'
    assert_equal 'value_rule', rule.type
    assert_equal 'legal_parent', rule.subject
    assert_equal 'attr_name', rule[:attr_name]
    assert_equal 'statement|of|rule', rule.statement
    assert_equal nil, rule.object
  end

  def tear_down
  end
end