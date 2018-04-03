require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
        
        provider: 'AWS',
        aws_access_key_id: 'AKIAIBAUHCLLB2ONIARQ',
        aws_secret_access_key: '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',
        region: 'us-west-2',
    }
    config.fog_directory = 'yorijori'
end