require 'json'

IaPrompts::ParseContent = lambda do |response_body|
	response_content = JSON.parse(response_body["choices"].first["message"]["content"])
end
