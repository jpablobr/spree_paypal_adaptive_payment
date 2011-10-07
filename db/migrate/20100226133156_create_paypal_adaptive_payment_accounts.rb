class CreatePaypalAdaptivePaymentAccounts < ActiveRecord::Migration
  def self.up
    create_table :paypal_adaptive_payment_accounts do |t|
      t.string :email
      t.string :payer_id
      t.string :appid
      t.string :payer_country
      t.string :payer_status
    end
  end

  def self.down
    drop_table :paypal_adaptive_payment_accounts
  end
end
