class SubscriptionsController < ApplicationController
  def create
    # Create a new customer in Stripe with the email and Stripe token received from the form.
    # The Stripe token represents the payment method details.
    customer = Stripe::Customer.create(
      email: params[:email],       
      source: params[:stripeToken]
    )

    subscription = Stripe::Subscription.create(
      customer: customer.id,
      items: [{ plan: 'price_1NBL2CKXaAfO4koHyASFxPkT' }]
    )
  
    # This uses the `create!` method, which will raise an exception if the record is invalid.
    Subscription.create!(
      email: customer.email,            
      stripe_customer_id: customer.id,   
      stripe_subscription_id: subscription.id
    )

    redirect_to root_path, notice: 'Subscription was successfully created'

  # Rescue block to catch any Stripe card errors during the subscription process.
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end
end
