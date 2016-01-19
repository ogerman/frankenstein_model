module FrankensteinModel
  class Attribute
    attr_accessor :name, :init_block, :getter, :setter, :parent_attribute

    def has_init?
      !@init_block.nil?
    end

    def has_parent?
      !@parent_attribute.nil?
    end

    def initialize(name, attribute_set, to: nil, init_block: nil, getter: nil, setter: nil)
      @name = name
      if init_block
        @init_block = init_block
      elsif to.is_a? Class
        @init_block = proc {to.new}
      elsif to.is_a? Symbol
        if attribute_set[to].nil?
          raise "unknown parent attribute :#{to}"
        else
          @parent_attribute = attribute_set[to]
          @init_block =  -> (obj, name, attrs) {obj.send(@parent_attribute.name)}
        end
      end

      if setter.nil?
        @setter = -> (obj_instance, attr_name, val) {
          obj_instance.send(:"#{attr_name}=", val)
        }
      else
        @setter = setter
      end

      if getter.nil?
        if to.nil? || to.is_a?(Class)
          @getter = -> (obj_instance, attr_name) {
            obj_instance
          }
        else
          @getter = -> (obj_instance, attr_name) {
            obj_instance.send(attr_name)
          }
        end
      else
        @getter = getter
      end
    end
  end
end