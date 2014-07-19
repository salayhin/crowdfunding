ActiveAdmin.register Order do
  menu :priority => 5
  actions :index, :show
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :uuid, :address_one, :address_two, :city, :state, :zip, :country, :phone, :name,
                :email, :billing_full_name, :billing_email, :billing_address1, :billing_address2,
                :billing_city, :billing_state, :billing_zip, :billing_country, :tracking_number,
                :billing_full_name, :billing_email, :id
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  index do
    column 'Order Id' do |order|
      order.uuid
    end
    column :first_name
    column :last_name
    column :email
    column :address_one
    column :address_two
    column :city
    column :zip
    column :country
    column :created_at
    actions
  end

  show do
    attributes_table do
      row 'Order Id' do |order|
        order.uuid
      end
      row :first_name
      row :last_name
      row :email
      row :address_one
      row :address_two
      row :city
      row :zip
      row :country
      row :billing_full_name
      row :billing_address1
      row :billing_address2
      row :billing_city
      row :billing_zip
      row :billing_country
      row :tracking_number
      row :created_at
    end

    panel 'Order Details' do
      attributes_table_for order.order_details do
        if order.order_details and order.order_details.count > 0
          div :class => "panel_contents" do
            div :class => "attributes_table shop_products" do
              table do
                tr do
                  th do
                    'Product'
                  end
                  th do
                    'Price'
                  end
                  th do
                    'Quantity'
                  end
                end
                tbody do
                  order.order_details.each do |o|
                    tr do
                      td do
                        link_to o.product.title, admin_product_path(o.product.id)
                      end
                      td do
                        number_to_currency(o.price)
                      end
                      td do
                        o.quantity
                      end
                    end
                  end
                end
              end
            end
          end
        else
          h3 'No Detail Found'
        end
      end
    end
  end


  scope_to do
    Class.new do
      def self.orders
        Order.order('created_at DESC')
      end
    end
  end

  #filter :order_uuid, :as => :string
  filter :status, :as=> :string
  filter :created_at
end
