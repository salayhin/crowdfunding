ActiveAdmin.register OrderDetail do
  menu false
  actions :index, :show
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :product_id, :price, :quantity, :order_id
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  index do
    column :product
    column :order_id
    column :price
    column :quantity
    actions
  end

  show do
    attributes_table do
      row :product
      row :order
      row :price
      row :quantity
    end
  end
  
end
