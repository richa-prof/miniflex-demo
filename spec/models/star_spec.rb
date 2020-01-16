require 'rails_helper'

RSpec.describe Star, type: :model do
  describe "associations" do
    it { should have_many(:movies_star) }
    it { should have_many(:movies).through(:movies_star) }
  end
end