class UrlValidator < ActiveModel::Validator
  def validate(input)
    unless ( (input.url.include? 'youtube') && ((input.url.include? 'http') || (input.url.include? 'https')))
      input.errors[:url] << 'Youtube video url(list/channel) only please! ex. https://www.youtube.com/watch?v=fhnlIBmVk6I'
    end
  end
end

class Video < ApplicationRecord
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_with UrlValidator
end
