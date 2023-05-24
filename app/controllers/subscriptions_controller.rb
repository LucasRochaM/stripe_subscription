class SubscriptionsController < ApplicationController
  def new
  end

  def create
    customer = Stripe::Customer.create(email: params[:stripeEmail], payment_method: params[:stripePaymentMethod])


    Stripe::PaymentMethod.attach(
      params[:stripePaymentMethod],
      { customer: customer.id }
    )

    subscription = Stripe::Subscription.create(
      customer: customer.id,
      items: [{ plan: 'price_1NBL2CKXaAfO4koHyASFxPkT' }],
      default_payment_method: params[:stripePaymentMethod]
    )

    Subscription.create!(
      email: customer.email,
      stripe_customer_id: customer.id,
      stripe_subscription_id: subscription.id
    )

    redirect_to root_path, notice: 'Subscription was successfully created'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end
end
