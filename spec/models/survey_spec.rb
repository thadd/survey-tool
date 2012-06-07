require 'spec_helper'

describe Survey do
  it "should list the most recently edited surveys first" do 
    first = Survey.timeless.create!(name: "First", updated_at: 3.days.ago)
    second = Survey.timeless.create!(name: "Second", updated_at: 2.days.ago)
    third = Survey.timeless.create!(name: "Third", updated_at: 1.day.ago)

    Survey.all.to_a.should eq([third, second, first])

    second.timeless.update_attributes(updated_at: Time.now)

    Survey.all.to_a.should eq([second, third, first])
  end

  it "should only allow valid XML" do
    survey = Survey.new(name: "Test", xml: "<this_is></invalid>")
    survey.should_not be_valid

    survey = Survey.new(name: "Test", xml: "<this_is_valid></this_is_valid>")
    survey.should be_valid
  end
end
