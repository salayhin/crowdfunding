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

  remove_filter :orders
  
end
