require_relative '../../../config'

module IAPrompts
	module FixTest
		module Content
			class << self
				def call
					<<~PROMPT
						Dado a classe a ser testada:
						```ruby
						#{class_being_tested}
						```


						```
						#{related_failes_text}"

						Ao rodar o arquivo de teste:
						```ruby
						#{file_test}
						```
						Recebo o seguinte output:
						```bash
						#{File.read(Config::OUTPUT_FAILURE_TESTS_PATH)}
						```

						Me retorne todo o arquivo de teste com a correção dos testes que falharam (a classe a ser testada não pode ser alterada nem ter testes removidos).
						O retorno no `content` deve ser em JSON para ser usado em um Hash do Ruby (IMPORTANTE: sem textos como ```json\n), com as seguintes chaves: `motivo_da_falha`, `arquivo_de_teste_corrigido`, `explicacao_da_solucao_realizada`.

						Por exemplo:
						#{json_model}

						Sempre use o `test_tenant` que é criado no ínicio da suíte para representar o `user` que na verdade é uma empresa, da seguinte forma: `let(:user) { test_tenant }`.

						Não use arquivos de fixtures.

						Não user stubs, mocks e fakes.

						Se a factory não existir não use factories, crie os objetos pela classe original.

						Se for um teste de Controller e precisar fazer login, use o método `login(user, pessoa)`.
					PROMPT
				end

				private

				def class_being_tested
					File.read(Config.class_being_tested_path)
				end

				def file_test
					File.read(Config.file_test_path)
				end

				def related_failes_text
					return "" if Config.related_files.none?

					"```Arquivos relacionados:\nruby\n#{Config.related_files.join("\n\n")}\n```\n\n"
				end

				def json_model
					{
						"motivo_da_falha" => "O teste 'Negocios::Stakeholder::Importacao#importa_async! enfileira um job de importação' falhou porque....",
					  "arquivo_de_teste_corrigido" => file_test_example
				  }.to_json
				end

				def file_test_example
					<<~RUBY
						require 'rails_helper'

						RSpec.describe Negocios::Stakeholder::Importacao, type: :model do
							let(:user) { test_tenant }

							describe '#importa_async!' do
								it 'enfileira um job de importação' do
									expect { Negocios::Stakeholder::Importacao.importa_async! }.to have_enqueued_job(ImportacaoJob)
								end
							end
						end
					RUBY
				end
			end
		end
	end
end
