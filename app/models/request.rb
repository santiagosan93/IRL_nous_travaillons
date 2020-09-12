class Request < ApplicationRecord
  after_create :send_confirmation_email

  validates :first_name, :last_name, :email, :bio, :phone_number, presence: true
  validates :email, uniqueness: true
  validates :phone_number, format: { with: /^((\+)33|0)[1-9](\d{2}){4}$/,
    message: "- Make sure you're typing in a french number", multiline: true }
  validates :email, format: { with: /([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/,
    message: "- You've entered an invalid email"}

  def remove_spaces_of_phone_number
    self.phone_number = self.phone_number.gsub(' ', '')
  end

  private

  def send_confirmation_email
    RequestMailer.with(request: self).confirmation.deliver_now
  end
end