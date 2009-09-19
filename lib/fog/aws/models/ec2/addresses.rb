module Fog
  module AWS
    class EC2

      def addresses
        Fog::AWS::EC2::Addresses.new(:connection => self)
      end

      class Addresses < Fog::Collection

        def all(public_ip = [])
          data = connection.describe_addresses(public_ip).body
          addresses = Fog::AWS::EC2::Addresses.new(:connection => connection)
          data['addressesSet'].each do |address|
            addresses << Fog::AWS::EC2::Address.new({
              :addresses  => self,
              :connection => connection
            }.merge!(address))
          end
          addresses
        end

        def create
          address = new
          address.save
          address
        end

        def new
          Fog::AWS::S3::Address.new(:connection => connection)
        end

      end

    end
  end
end
