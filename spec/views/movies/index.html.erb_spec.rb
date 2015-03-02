require 'rails_helper'

RSpec.describe "movies/index", :type => :view do
  it "renders list of movies" do
    assign(:movies, [Movie.create(title: 'lord of the rings')])
    render
    expect(rendered).to include('lord-of-the-rings')
  end
end
