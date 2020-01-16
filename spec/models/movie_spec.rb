require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe "associations" do
    it { should have_many(:movies_genre) }
    it { should have_many(:genres).through(:movies_genre) }
    it { should have_many(:movies_star) }
    it { should have_many(:stars).through(:movies_star) }
  end
end
