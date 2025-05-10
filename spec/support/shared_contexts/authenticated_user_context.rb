RSpec.shared_context "authenticated user" do
  let(:user) { create(:user) }
  let(:session) { create(:session, user:) }

  before do
    allow(Current).to receive(:session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
  end
end
