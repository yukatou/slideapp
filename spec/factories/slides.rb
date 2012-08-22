# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :slide do
    tite "MyString"
    description "MyText"
    status ""
    path "MyString"
    user nil
  end
end
