class AttributeSet

  def initialize(klass)
    @klass = klass
    @index = {}
  end

  def add(attribute)
    @index[attribute.name] = attribute
  end

  def [](name)
    @index[name]
  end

  def init_and_define_methods(obj, attrs)
    @index.each_pair { |name, attribute|

      if attribute.has_init?
        object = attribute.init_block.call(obj, name, attrs)
      else
        object = obj
      end

      obj.define_singleton_method(name) do
        attribute.getter.call(object, name)
      end

      obj.define_singleton_method(:"#{name}=") do |val|
        attribute.setter.call(object, name, val)
      end
    }

    attrs.each_pair { |key, val|
      obj.send(:"#{key}=", val) if obj.respond_to?(:"#{key}=")
    } unless attrs.nil?
  end

end