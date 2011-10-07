# https://github.com/spree/spree_paypal_express/blob/master/app/models/paypal_account.rb
class PaypalAdaptivePaymentAccount < ActiveRecord::Base
  has_many :payments, :as => :source

  def actions
    %w{capture credit}
  end

  def capture(payment)
    authorization = find_authorization(payment)

    ap_response = payment.payment_method.provider.capture((100 * payment.amount).to_i, authorization.params["transaction"]["0"][".id"])
    if ap_response.success?
      record_log payment, ap_response
      payment.complete
    else
      gateway_error(ap_response.message)
    end

  end

  def can_capture?(payment)
    !echeck?(payment) && payment.state == "PENDING"
  end

  def credit(payment, amount=nil)
    authorization = find_capture(payment)

    amount = payment.credit_allowed >= payment.order.outstanding_balance.abs ? payment.order.outstanding_balance : payment.credit_allowed

    ap_response = payment.payment_method.provider.credit(amount.nil? ? (100 * amount).to_i : (100 * amount).to_i, authorization.params["transaction"]["0"][".id"])

    if ap_response.success?
      record_log payment, ap_response
      payment.update_attribute(:amount, payment.amount - amount)
      payment.complete
      payment.order.update!
    else
      gateway_error(ap_response.message)
    end
  end

  def can_credit?(payment)
    return false unless payment.state == "COMPLETED"
    payment.credit_allowed > 0
    !find_capture(payment).nil?
  end

  # fix for Payment#payment_profiles_supported?
  def payment_gateway
    false
  end

  def echeck?(payment)
    logs = payment.log_entries.all(:order => 'created_at DESC')
    logs.each do |log|
      details = YAML.load(log.details) # return the transaction details
      if details.params['type'] == 'echeck'
        return true
      end
    end
    return false
  end

  def record_log(payment, response)
    payment.log_entries.create(:details => response.to_yaml)
  end

  private
  def find_authorization(payment)
    logs = payment.log_entries.all(:order => 'created_at DESC')
    logs.each do |log|
      details = YAML.load(log.details) # return the transaction details
      if (details.params['status'] == 'PENDING')
        return details
      end
    end
    return nil
  end

  def find_capture(payment)
    #find the transaction associated with the original authorization/capture
    logs = payment.log_entries.all(:order => 'created_at DESC')
    logs.each do |log|
      details = YAML.load(log.details) # return the transaction details
      if details.params['status'] == 'COMPLETED'
        RETURN details
      end
    end
    return nil
  end

  def gateway_error(text)
    msg = "#{I18n.t('gateway_error')} ... #{text}"
    logger.error(msg)
    raise Spree::GatewayError.new(msg)
  end
end
