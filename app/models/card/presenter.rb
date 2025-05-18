module Card::Presenter
  extend ActiveSupport::Concern

  included do
    def image
      "https://lbpdev.us-mia-1.linodeobjects.com/active_deck/cards/#{rank_for_image}#{suit[0]}.png"
    end

    def to_html
      element = <<~HTML
        <div class="flex flex-col gap-2#{["Diamond", "Heart"].include?(suit) && " text-red-500"}">
          #{self}
        </div>
      HTML
      element.html_safe
    end

    def to_s
      "#{rank} #{suit_icon}"
    end

    def as_json
      {
        id:,
        suit:,
        rank:
      }
    end

    private

    def rank_for_image
      (rank == "10") ? "0" : rank
    end

    def suit_icon
      case suit
      when "Spade" then "♠"
      when "Heart" then "♥"
      when "Diamond" then "♦"
      when "Club" then "♣"
      end
    end
  end
end
