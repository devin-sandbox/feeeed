class NotificationWebhook < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :url, presence: true, length: { maximum: 2083 }

  def notify_reactions(recent: 24.hours.ago)
    reactions = user.reactions.where("created_at >= ?", recent).order(id: :desc)
    return if reactions.empty?

    content = "@#{user.name}'s recent pawprints 🐾"
    embeds =
      reactions.map { |reaction|
        {
          title: [reaction.item.title, reaction.item.channel.title].join(" | "),
          description: reaction.memo.present? ? "💬 #{reaction.memo}" : nil,
          url: reaction.item.url,
          thumbnail: { url: reaction.item.image_url_or_placeholder },
        }
      }

    Faraday.post(
      url, { content:, embeds: }.to_json, "Content-Type" => "application/json"
    )
  end
end
