ActiveAdmin.register Transaction do
  menu :priority => 6
  actions :index, :show
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :order_id, :order_total, :stripe_charge_id, :stripe_customer_id, :card_last_4_digit,
                :card_brand, :card_exp_month, :card_exp_year, :is_refunded, :refund_amount,
                :is_paid, :stripe_charge, :status
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  index do
    column :order_id
    column :order_total
    column :stripe_charge_id
    column :is_refunded
    column :status
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :order_id
      row :order_total
      row :stripe_charge_id
      row :stripe_customer_id
      row :card_last_4_digit
      row :card_last_4_digit
      row :card_brand
      row :card_exp_month
      row :card_exp_year
      row :is_refunded
      row :refund_amount
      row :status
      row :created_at
    end
  end

  #filter :order
  filter :stripe_charge_id, as: :string
  filter :status, as: :string
  filter :is_refunded
  filter :created_at

end
