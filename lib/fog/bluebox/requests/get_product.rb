module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_product'

      # Get details of a product
      #
      # ==== Parameters
      # * product_id<~Integer> - Id of flavor to lookup
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      # TODO
      def get_product(product_id)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetFlavor.new,
          :path     => "api/block_products/#{flavor_id}.xml"
        )
      end

    end

    class Mock

      def get_product(product_id)
        Fog::Mock.not_implemented
      end

    end
  end
end
