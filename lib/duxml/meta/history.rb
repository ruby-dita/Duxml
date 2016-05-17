require File.expand_path(File.dirname(__FILE__) + '/history/add')
require File.expand_path(File.dirname(__FILE__) + '/history/remove')
require File.expand_path(File.dirname(__FILE__) + '/history/validate_error')
require File.expand_path(File.dirname(__FILE__) + '/history/qualify_error')
require File.expand_path(File.dirname(__FILE__) + '/history/new_attr')
require File.expand_path(File.dirname(__FILE__) + '/history/change_attr')
require File.expand_path(File.dirname(__FILE__) + '/history/new_text')
require File.expand_path(File.dirname(__FILE__) + '/history/change_text')
require File.expand_path(File.dirname(__FILE__) + '/history/undo')
require File.expand_path(File.dirname(__FILE__) + '/../doc')
require 'forwardable'

module Duxml
  module History
    include Duxml
    include Reportable
  end

  class HistoryClass
    include History
    extend Forwardable

    def_delegators :@nodes, :[], :each

    def initialize(harsh_or_kind = true)
      @nodes = []
      @strict = harsh_or_kind
    end

    attr_reader :nodes
    alias_method :events, :nodes
  end

  module History
    # used when creating a new metadata file for a static XML file
    #
    # @return [Element] XML element for a new <duxml:history> node
    def self.xml
      Element.new(name.nmtokenize).extend self
    end

    # @return [Boolean] toggles (true by default) whether History will raise exception or tolerate qualify errors
    def strict?(harsh_or_kind=nil)
      @strict = harsh_or_kind.nil? ? @strict : harsh_or_kind
      @strict
    end

    def latest
      events[0]
    end

    # @return [GrammarClass] grammar that is observing this history's events
    def grammar
      @observer_peers.first.first if @observer_peers and @observer_peers.any? and @observer_peers.first.any?
    end

    def description
      "history follows: \n" +
      events.collect do |change_or_error|
        change_or_error.description
      end.join("\n")
    end

    # receives reports from interface of changes or from Duxml::Rule violations
    def update(type, *args)
      change_class = Duxml::const_get "#{type.to_s}Class".to_sym
      change_comp = change_class.new *args
      @nodes.unshift change_comp
      changed
      notify_observers(change_comp) unless change_comp.respond_to?(:error?)
      raise(Exception, change_comp.description) if strict? && type == :QualifyError
    end
  end # module History
end # module Duxml