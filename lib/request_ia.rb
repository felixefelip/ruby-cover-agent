require 'httparty'
require_relative '../config.rb'

module RequestIA
	class << self
		def call(content)
			puts "Fazendo a requisição para a API..."

			body = {
				model: Config::MODEL,
				messages: [{ role: 'user', content: content }]
			}.to_json

			headers = {
				'Content-Type' => 'application/json',
				'Authorization' => "Bearer #{Config::API_KEY}"
			}

			HTTParty.post(Config::URL, body: body, headers: headers, read_timeout: 200)
		end
	end
end
