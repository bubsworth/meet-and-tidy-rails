require "rails_helper"

RSpec.describe "Events admin", type: :request do
  before do
    sign_in FactoryBot.create(:administrator)
  end

  describe "GET /admin/events" do
    it "lists all events" do
      FactoryBot.create(:event, title: "Locke Park Cleanup")
      FactoryBot.create(:event, title: "Cleethorpes Beach Cleanup")

      get "/admin/events"
      expect(response.body).to include("Locke Park Cleanup")
      expect(response.body).to include("Cleethorpes Beach Cleanup")
    end
  end

  describe "GET /admin/events/new" do
    it "renders a form for a new event" do
      get "/admin/events/new"
      assert_select "form[action='#{admin_events_path}']" do
        assert_select(
          "input[type=text][name='event[title]'][required]"
        )
      end
    end
  end

  describe "POST /admin/events" do
    let(:params) do
      {
        title: "Copley Road Litterpick"
      }
    end

    before do
      post "/admin/events", params: {event: params}
    end

    it "creates a new event" do
      event = Event.last
      expect(event).to be
      expect(event.title).to eq "Copley Road Litterpick"
    end

    it "redirects to events index" do
      expect(response).to redirect_to admin_events_path
    end

    it "sets a flash notice" do
      expect(flash[:notice]).to eq "Added new event."
    end
  end

  describe "GET /admin/events/:id/edit" do
    let(:event) { FactoryBot.create(:event) }

    it "renders a form to edit the event" do
      get "/admin/events/#{event.id}/edit"
      assert_select "form[action='#{admin_event_path(event)}']"
    end
  end

  describe "PATCH /admin/events/:id" do
    context "with valid params" do
      before do
        @event = FactoryBot.create(
          :event, title: "Locke Park Cleanup"
        )
        patch(
          "/admin/events/#{@event.id}",
          params: {
            event: {title: "Cleethorpes Beach Cleanup"}
          }
        )
      end

      it "updates the event" do
        @event.reload
        expect(@event.title).to eq "Cleethorpes Beach Cleanup"
      end

      it "redirects to admin events path" do
        expect(response).to redirect_to admin_events_path
      end
    end
  end

  describe "DELETE /admin/events/:id" do
    let(:event) { FactoryBot.create(:event) }
    before { delete "/admin/events/#{event.id}" }

    it "destroys the event" do
      expect(Event.exists?(event.id)).to be_falsey
    end

    it "redirects to events index" do
      expect(response).to redirect_to admin_events_path
    end

    it "sets a flash notice" do
      expect(flash[:notice]).to eq "Event deleted."
    end
  end
end