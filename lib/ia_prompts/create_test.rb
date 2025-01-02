require 'pry'
require_relative './../request_ia'

module IaPrompts
	module CreateTest
		class << self
			def call
				puts "\e[34m\n\nClasse não possui testes. Criando testes do zero...\n\n\e[0m"
				response = RequestIA.call(content)

				response_body = JSON.parse(response.body)

				puts response_body

				response_content = JSON.parse(response_body["choices"].first["message"]["content"])

				FileUtils.mkdir_p(File.dirname(Config.file_test_path))

				File.open(Config.file_test_path, 'w') do |file|
					file.puts response_content['arquivo_de_teste_gerado']
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

					Seu trabalho será criar testes com RSpec que abrangem boa parte dos cenários, e retornar a classe de testes e a explicação no formato JSON, com par chave-valor.

					Não use arquivos de fixtures.

					Se for um teste de Controller e precisar fazer login, use o método `login(user, pessoa)`.

          Aqui está como é o retorno que eu espero:"
					#{json_model}

					Não retorne no ínicio "```json" ou algo do tipo, apenas o JSON puro.
				PROMPT
			end

			def json_model
				#Crie testes com RSpec que abrangem boa parte dos cenários. Não use arquivos de fixtures. retorno no `content` deve ser em JSON para ser usado em um Hash do Ruby (sem coisas como ```json\n), com as seguintes chaves: `arquivo_de_teste_gerado`, `explicacao_da_solucao_realizada`. Por exemplo: {\"arquivo_de_teste_gerado\": \"require 'rails_helper'\\n\\nRSpec.describe Negocios::Stakeholder::Importacao, typ...\n\n"\
				{
					"arquivo_de_teste_gerado": "require 'rails_helper'\\n\\nRSpec.describe Negocios::Stakeholder::Importacao, typ...\n\n",
					"explicacao_da_solucao_realizada": "Aqui está a explicação da solução realizada...",
				}
			end
		end
	end
end
