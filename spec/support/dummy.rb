require 'virtus'

module Dummy
  class User
    include Virtus.model
    attribute :email, String
    attribute :password, String
    attribute :data, Hash

    attribute :tel
    attribute :fax
  end

  class Company
    include Virtus.model
    attribute :users, Array[User]

    attribute :name, String
    attribute :country, String
    attribute :type

    attribute :tel
    attribute :fax
  end

  class Registration
    include FrankensteinModel
    tie :user, to: User
    tie :company do |registration|
      Company.new(users: [registration.user])
    end

    tie :name, :country, :type, to: :company
    tie :email, :password, to: :user
    tie :address1, :address2, to: :user,
      setter: -> (user, attr_name, val) { user.data[attr_name] = val},
      getter: -> (user, attr_name) { user.data[attr_name] }

    tie :fax, :tel,
      setter: -> (reg, attr_name, val) {
        if reg.type == "LCC"
          reg.company.send(:"#{attr_name}=", val)
        else
          reg.user.send(:"#{attr_name}=", val)
        end
      },
      getter: -> (reg, attr_name) {
        if reg.type == "LCC"
          reg.company.send(attr_name)
        else
          reg.user.send(attr_name)
        end
      }
  end
end