require "rails_helper"

describe 'Movie' do
  describe 'search movies with similar director' do
    it 'should call Movie with director' do
    	expect(Movie).to receive(:similar_director).with("Star Wars")
    	Movie.similar_director("Star Wars")
    end
  end
end