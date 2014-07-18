ActiveAdmin.register Product do
  menu :priority => 4
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :title, :amount, :amount, :amount_display, :description, :shipping_desc, :limit, :is_published
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  index do
    column :title
    column 'Description' do |product|
      product.description.html_safe
    end
    column :amount
    column 'Quantity' do |product|
      product.limit
    end
    column :is_published
    column :shipping_desc
    column :delivery_desc
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row 'Description' do |product|
        product.description.html_safe
      end
      row :amount
      row 'Quantity' do |product|
        product.limit
      end
      row :is_published
      row :shipping_desc
      row :delivery_desc
      row :created_at
    end

  end

  remove_filter :orders
  filter :title , as: :string
  filter :is_published
  filter :created_at

end
