require "rails_helper"

describe MoviesController do
	describe 'add director' do
	  before :each do
	    @movie = double('Movie', :title => "Star Wars", :director => "director", :id => "1")
	    allow(Movie).to receive(:find).with("1").and_return(@movie)
	  end
	  it 'should call update_attributes and redirect' do
	    allow(@movie).to receive(:update_attributes!).and_return(true)
	    data = {title: "Star Wars", director: "director", id: "1"}
	    put :update, {:id => "1", :movie => data}
	    expect(response).to redirect_to(movie_path(@movie))
	  end
	end

	describe 'sort' do
		it 'should sort by title' do
      		get 'index', {:ratings => "G", :sort => "title"}
      		expect(response).to redirect_to({:sort => "title", :ratings => "G"})
    	end
    	it 'should sort by release_date' do
      		get 'index', {:ratings => "G", :sort => "release_date"}
      		expect(response).to redirect_to( sort: "release_date", ratings: "G" )
    	end
	end

	describe 'happy path' do
	  before :each do
	    @movie = double(Movie, title: "Star Wars", director: "George Lucas", id: "1")
	    allow(Movie).to receive(:find).with("1").and_return(@movie)
	  end

	  it 'should generate route for Similar Movies' do
	  	expect({ :get => movie_similar_path(1) }).to route_to(:controller => "movies", :action => "similar", :movie_id => "1")
	  end

	  it 'should call the model method that finds similar movies' do
	  	fake_results = [double(Movie), double(Movie)]
	  	expect(Movie).to receive(:similar_director).with("George Lucas").and_return(fake_results)
	  	get :similar, :movie_id => "1"
	  end

	  it 'should select the similar template for rendering and make result available' do
	  	allow(Movie).to receive(:similar_director).with("George Lucas").and_return(@movie)
	  	get :similar, :movie_id => "1"
	  	expect(response).to render_template("similar")
	  	expect(assigns(:movies)).to eq(@movie)
	  end
	end

	describe 'sad path' do
	  before :each do
	    @movie = double('Movie', :title => "Star Wars", :director => nil, :id => "1")
	    allow(Movie).to receive(:find).with("1").and_return(@movie)
	  end

	  it 'should generate routing for Similar Movies' do
	    expect({ :get => movie_similar_path(1) }).to route_to(:controller => "movies", :action => "similar", :movie_id => "1")
	  end
	  it 'should select the Index template for rendering and generate a flash' do
	    get :similar, :movie_id => "1"
	    expect(response).to redirect_to(movies_path)
	    expect(flash[:notice]).not_to eq(be_blank)
	  end
	end

  	describe 'create and destroy' do
      it 'should create a new movie' do
      	movie = {"title"=>"John Dieas At The End", "rating"=>"PG-13", "release_date(1i)"=>"2015", "release_date(2i)"=>"12", "release_date(3i)"=>"3"}
      	expect(Movie).to receive(:create!).with(movie).and_return(instance_double(Movie, title: "John Dies At The End"))
        post :create, movie: movie
      end
      it 'should destroy a movie' do
        movie = double(Movie, :id => "10", :title => "John Dies At The End", :director => nil)
        allow(Movie).to receive(:find).with("10").and_return(movie)
        expect(movie).to receive(:destroy)
        delete :destroy, {:id => "10"}
      end
 	end
end