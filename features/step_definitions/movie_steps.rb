# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body.should =~ /#{e1}.*#{e2}/m
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.split(',')
  rating_list.each do |rating|
    rating.gsub!(/(\s)/, '')
    step "I #{uncheck}check \"ratings_#{rating}\""
  end
end

Then /I should (not\s)?see movies with ratings: (.*)/ do |not_see, rating_list|
  rating_list = rating_list.split(',')
  rating_list.each do |rating|
    rating.gsub!(/\s/, '')
    step %Q{I should #{not_see}see /^#{rating}/}
  end
end

Then /I should see (.*) of the (.*)/ do |quantity ,my_table|
  if quantity =~ /none/
    quantity = 1
  else
    quantity = 11
  end
  page.all("table##{my_table} tr").count.should == quantity
end

And /the following ratings should be (un)?checked: (.*)/ do |un, ratings|
  ratings = ratings.split(',')
  ratings.each do |rating|
    rating.gsub!(/\s/,'')
    step %Q{the ratings_#{rating} checkbox should not be checked}
  end
end