require 'json'
require_relative '../../config.rb'
require_relative '../request_ia.rb'
require_relative './fix_test/content.rb'

module IAPrompts
  module FixTest
    class << self
      def call
        fix_test_with_ia
      end

      private

      def fix_test_with_ia
        response = RequestIA.call(Content.call)

        response_body = JSON.parse(response.body)

        # Imprimir a resposta da API
        puts JSON.pretty_generate(response_body)
        puts "\n\n\n\n"

        if response_body["error"] && response_body["error"]["message"] && response_body["error"]["message"].include?("Rate limit reached")
          puts "Rate limit reached. Please try again later."
          sleep 5
          return
        end

        response_content = JSON.parse(response_body["choices"].first["message"]["content"])

        failure_motives = response_content['motivo_da_falha']
        file_test_adjusted = response_content['arquivo_de_teste_corrigido']
        explicacao_da_solucao_realizada = response_content['explicacao_da_solucao_realizada']

        puts "Motivo da falha: #{failure_motives}\n\n"
        puts "Arquivo de teste ajustado: #{file_test_adjusted}\n\n"
        puts "Explicação da solução realizada: #{explicacao_da_solucao_realizada}\n\n"


        write_solution_to_test_file(file_test_adjusted)
      rescue JSON::ParserError => e
        puts "Erro ao fazer parse do JSON: #{e}"
      end

      def write_solution_to_test_file(file_test_adjusted)
        File.open(Config.file_test_path, 'w') do |file|
          file.puts file_test_adjusted
        end
      end
    end
  end
end
