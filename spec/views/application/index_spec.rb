require 'rails_helper'

RSpec.describe "application/index", :type => :view do
  it 'check if it shows the most recent movie' do
    assign(:movie, Movie.create(title: 'gladiator'))
    render
    expect(rendered).to include ('gladiator')
  end
end
