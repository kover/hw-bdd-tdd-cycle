Given /^the following movies exist:$/ do |movies|
	movies.hashes.each { |movie| Movie.create!(movie) }
end

Then /^the director of "([^"]+)" should be "([^"]+)"$/ do |movie, director|
	expect(page.body).to have_content(/#{movie}.+Director.+#{director}/m)
end