require 'fog/model'

module Fog
  module AWS
    module EC2

      class SecurityGroup < Fog::Model

        identity  :name,            'groupName'

        attribute :description,     'groupDescription'
        attribute :ip_permissions,  'ipPermissions'
        attribute :owner_id,        'ownerId'

        def authorize_group_and_owner(group, owner)
          requires :name

          connection.authorize_security_group_ingress(
            'GroupName'                   => @name,
            'SourceSecurityGroupName'     => group,
            'SourceSecurityGroupOwnerId'  => owner
          )
        end

        def authorize_port_range(range, options = {})
          requires :name

          connection.authorize_security_group_ingress(
            'CidrIp'      => options[:cidr_ip] || '0.0.0.0/0',
            'FromPort'    => range.min,
            'GroupName'   => @name,
            'ToPort'      => range.max,
            'IpProtocol'  => options[:ip_protocol] || 'tcp' 
          )
        end

        def destroy
          requires :name

          connection.delete_security_group(@name)
          true
        end

        def save
          requires :description, :name

          data = connection.create_security_group(@name, @description).body
          true
        end

      end

    end
  end
end
