# Add a declarative step here for populating the DB with movies.

class String
  def hashes
    movie_arr = []
    header = []
    self.each_line.with_index do |word,i|
      #puts "Iteration number - #{i}"
      if i == 0
        header = word.split('|').map { |s| s.strip}.reject { |s| s == ''}
      else
        movie_line = {}
        movie = word.split('|').map { |s| s.strip}.reject { |s| s == ''}
        movie.each.with_index do |field,i|  #need to create hash with field and value for each movie
          movie_line[header[i]] = field
        end
        movie_arr << movie_line
      end
    end
    return movie_arr
  end
end

def add_movie(movie)
  Movie.create!(movie)
end

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
     add_movie(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
    e1_pos = page.body.index(e1)
    e2_pos = page.body.index(e2)
    assert e1_pos < e2_pos
end

#Then /I should see "(.*)" before "(.*)"/ do |string1, string2|
#  #step "I am on #{path}"
#  regexp = /#{string1}.*#{string2}/m #  /m means match across newlines
#  page.body.should =~ regexp
#end


# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

# HINT: use String#split to split up the rating_list, then
#   iterate over the ratings and reuse the "When I check..." or
#   "When I uncheck..." steps in lines 89-95 of web_steps.rb


Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(", ").each do |r|
    if uncheck
      uncheck("ratings_#{r}")
    else
      check("ratings_#{r}")
    end
  end
end

Then /^I should not see any movies/ do
  if page.respond_to? :should
    page.should have_css('table#movies tbody tr', :count => 0)
  else
    assert page.has_css?('table#movies tbody tr', :count => 0)
  end
end

Then /^I should see all of the movies/ do
  if page.respond_to? :should
    page.should have_css('table#movies tbody tr', :count => 10)
  else
    assert page.has_css?('table#movies tbody tr', :count => 10)
  end
end

Then /I should see the following movies: (.*)/ do |movies|
    movies.split(",").each do |title|
      if page.respond_to? :should
        page.should have_content(title)
      else
        assert page.has_content?(title)
      end
    end
end

Then /I should not see the following movies: (.*)/ do |movies|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end


