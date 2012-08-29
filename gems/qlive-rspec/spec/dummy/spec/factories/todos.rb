FactoryGirl.define do

  factory :todo do
    todo_list { TodoList.first || FactoryGirl.create(:todo_list) }
    content { "#{random_letters(3).titleize} the #{random_letters(4).titleize}" }
  end

end


LETTER_ARRAY ||= ('a'..'z').to_a
def random_letters(n=8)
  n.times.map { LETTER_ARRAY[rand(26)] }.join
end
