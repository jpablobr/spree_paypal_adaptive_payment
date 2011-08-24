Rails.application.routes.draw do
  resources :orders do
    resource :checkout, :controller => 'checkout' do
      member do
        get :paypal_adaptive_payment_checkout
        get :paypal_adaptive_payment
        get :paypal_adaptive_payment_confirm
        post :paypal_adaptive_payment_finish
      end
    end
  end

  match '/checkout/paypal_adaptive_payment_finish' => 'checkout#paypal_adaptive_payment_finish', :via => [:get, :post]
  match '/paypal_adaptive_payment_notify' => 'paypal_adaptive_payment_callbacks#notify', :via => [:get, :post]

  namespace :admin do
    resources :orders do
      resources :paypal_adaptive_payments do
        member do
          get :refund
          get :capture
        end
      end
    end
  end
end
