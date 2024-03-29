require "rails_helper"

RSpec.describe Event, type: :model do
  describe "Active Storage" do
    it { should have_many_attached :images }
  end

  describe "Associations" do
    it { should belong_to :event_type }
    it { should have_and_belong_to_many :facilities }
    it { should have_many(:attendances) }
    it { should have_many(:users).through(:attendances) }
  end

  describe "Validations" do
    it { should validate_presence_of :location }
    it { should validate_presence_of :title }
  end

  describe "#formatted_location" do
    it "returns location appended with ',UK'" do
      event = Event.new(title: "Locke Park Cleanup", location: "Doncaster")
      expect(event.formatted_location).to eq "Doncaster, UK"
    end
  end

  describe "#to_s" do
    it "returns its title" do
      expect(Event.new(title: "Locke Park Cleanup").to_s).to eq "Locke Park Cleanup"
    end
  end
end
