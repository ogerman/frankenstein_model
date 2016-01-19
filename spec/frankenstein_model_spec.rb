require 'spec_helper'
describe FrankensteinModel do

  subject {
    Dummy::Registration.new
  }

  it {
    expect(subject.company).to be_kind_of(Dummy::Company)
  }

  it {
    expect(subject.user).to be_kind_of(Dummy::User)
  }

  it {
    expect(subject.user).to eq(subject.company.users.first)
  }

  it {
    expect { subject.email = "foo@bar.baz" }.to change {subject.user.email }.from(nil).to("foo@bar.baz")
  }

  it {
    subject.email = "foo@bar.baz"
    expect(subject.email).to eq("foo@bar.baz")
  }

  it {
    expect {
      subject.address1 = "25th Street"
    }.to change {subject.user.data }.from({}).to({:address1=>"25th Street"})
  }

  it {
    subject.address1 =  "25th Street"
    expect(subject.address1).to eq("25th Street")
  }

  it {
    subject.type = "LCC"
    expect {
      subject.fax = "001234556"
    }.to change {subject.company.fax }.from(nil).to("001234556")

    expect {
      subject.tel = "001234556"
    }.to_not change {subject.user.tel }
  }

  it {
    expect {
      subject.fax = "001234556"
    }.to change {subject.user.fax }.from(nil).to("001234556")

    expect {
      subject.tel = "001234556"
    }.to_not change {subject.company.tel }
  }

  it {
    reg = Dummy::Registration.new(type: "LCC", fax: '001234556')
    expect(reg.company.fax).to eq("001234556")
  }
end