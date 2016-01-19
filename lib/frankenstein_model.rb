require "frankenstein_model/version"
require "frankenstein_model/attribute"
require "frankenstein_model/attribute_set"

module FrankensteinModel

  def self.included(base)
    base.instance_variable_set('@attribute_set', AttributeSet.new(base))
    base.extend(ClassMethods)
    base.include(InstanceMethods)
    base.class_eval { include InstanceMethods::Constructor }

  end

  module ClassMethods

    def tie(*attrs, to: nil, setter: nil, getter: nil, &init_block)
      if attrs.is_a? Array
        attrs.each{ |a| tie_attribute(a, to: to, setter: setter, getter: getter, &init_block) }
      else
        tie_attribute(attrs, to: to, setter: setter, getter: getter, &init_block)
      end
    end

    def tie_attribute(name, to: nil, setter: nil, getter: nil, &init_block)
      attribute_set.add Attribute.new(name, attribute_set, to: to, setter: setter, getter: getter, init_block: init_block)
    end

    def attribute_set
      @attribute_set
    end
  end

  module InstanceMethods
    module Constructor
      def initialize(attributes = nil)
        attribute_set.init_and_define_methods(self, attributes)

        # attribute_set.set(self, attributes) if attributes
        # set_default_attributes
      end

      private

      def attribute_set
        self.class.attribute_set
      end

    end
  end

end
