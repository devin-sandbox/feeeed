class User < ApplicationRecord
  has_many :ownerships, dependent: :destroy
  has_many :owned_channels, through: :ownerships, source: :channel
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_channels, through: :subscriptions, source: :channel
  has_many :subscribed_items, through: :subscribed_channels, source: :items
  has_many :reactions, dependent: :destroy
  has_many :reacted_items, through: :reactions, source: :item

  validates :name, presence: true, length: { in: 2..15 }
  validates :email, presence: true, length: { maximum: 254 }
  validates :icon_url, presence: true, length: { maximum: 2083 }

  def add_channel(channel)
    owned_channels << channel
  end

  def remove_channel(channel)
    owned_channels.delete(channel)
  end

  def subscribe(channel)
    subscribed_channels << channel
  end

  def unsubscribe(channel)
    subscribed_channels.delete(channel)
  end

  def add_reaction(item, memo:)
    reactions.find_or_initialize_by(item: item).update(memo: memo.presence)
  end

  def remove_reaction(item)
    reactions.find_by(item: item).destroy
  end

  def reacted_to?(item)
    reacted_items.include?(item)
  end
end
