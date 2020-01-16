require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe "associations" do
    it { should have_many(:movies_genre) }
    it { should have_many(:movies).through(:movies_genre) }
  end
end