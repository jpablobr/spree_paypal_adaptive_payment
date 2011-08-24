class BillingIntegration::PaypalAdaptivePayment < BillingIntegration
  preference :login, :string
  preference :password, :password
  preference :signature, :string
  preference :appid, :string
  preference :review, :boolean, :default => false
  preference :no_shipping, :boolean, :default => false
  preference :currency, :string, :default => 'USD'

  def provider_class
    # This relies on https://github.com/jpablobr/active_paypal_adaptive_payment
    ActiveMerchant::Billing::PaypalAdaptivePayment
  end

  # Spree requires this method for the profiles implementation.
  # http://spreecommerce.com/documentation/checkout.html#payment-profiles
  # def create_profile(payment); end

  # Set this to true in order to display the confirm state
  # in the checkout process...
  def payment_profiles_supported?
    false
  end

end
