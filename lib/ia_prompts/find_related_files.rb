require_relative './../request_ia'

module IaPrompts
	module FindRelatedFiles
		class << self
			def call
				puts "\e[34mClasse não possui arquivos relacionados para testes. Buscando arquivos pela IA...\e[0m"
				response = RequestIA.call(content)

				response_body = JSON.parse(response.body)

				puts response_body

				response_content = JSON.parse(response_body["choices"].first["message"]["content"])

				puts response_content['explicacao_arquivos_relacionados']

				File.open(Config::RELATED_FILES_DB_PATH, 'w') do |file|
					file.puts response_content['arquivos_relacionados_paths']
				end
			rescue JSON::ParserError => e
        puts "Erro ao fazer parse do JSON: #{e}"
			end

			private

			def content
				<<~PROMPT
					Dado a classe:
					```ruby
					#{File.read(Config.class_being_tested_path)}
					```

					Liste no máximo 4 arquivos relacionados que são importantes para os testes, pode ser models factories, etc."
					Os arquivos do projeto de factories e libs são:
					```txt
					#{File.read(Config::PROJECT_FILES_PATH)}
					```

					Aqui está como é o retorno que eu espero:"
					#{json_model}

					Não retorne no ínicio "```json" ou algo do tipo, apenas o JSON puro.
			  PROMPT
			end

			def json_model
				{
					"arquivos_relacionados_paths" => %w[spec/factories/users.rb app/models/user.rb],
					"explicacao_arquivos_relacionados" => "Aqui está a explicação da solução realizada...",
			  }.to_json
			end
		end
	end
end
