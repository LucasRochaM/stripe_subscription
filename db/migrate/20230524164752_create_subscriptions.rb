class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.string :stripe_customer_id
      t.string :stripe_subscription_id

      t.timestamps
    end
  end
end
