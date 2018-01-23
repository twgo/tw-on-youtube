class UrlValidator < ActiveModel::Validator
  def validate(input)
    # (input.url.exclude? 'list') &&
    unless ((input.url.exclude? 'channel') && (input.url.include? 'youtube') && ((input.url.include? 'http') || (input.url.include? 'https')))
      input.errors[:url] << 'Youtube single video url only please! ex. https://www.youtube.com/watch?v=fhnlIBmVk6I'
    end
  end
end

class Video < ApplicationRecord
  validates_presence_of :url
  # validates_uniqueness_of :url
  validates_with UrlValidator
end
