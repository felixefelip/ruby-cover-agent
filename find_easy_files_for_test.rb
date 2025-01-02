require 'json'
require_relative 'lib/runner'

cov = JSON.parse File.read("/home/felix/Documents/maino/coverages/coverage4/coverage.json")

easy_files = cov["files"].select do |f|
	f["covered_percent"].zero? && f["lines_of_code"] <= 150 && !f['filename'].include?("app/channels") && !f['filename'].include?("pjbank") && !f['filename'].include?("traxo") && f['filename'].include?("app/models") && !File.read(Config::SUCCESS_FILE_TESTS_PATH).include?(f['filename'])
end

lines_of_code_total = easy_files.sum { |f| f["lines_of_code"] }

puts "Total de arquivos para testar: #{easy_files.size}"
puts "Total de linhas para testar: #{lines_of_code_total}"

easy_files.shuffle.first(20).each do |f|
	Config.class_being_tested_sufix_path = f["filename"].sub("/home/felix/Documents/ruby-workspace/maino/", "")

	puts "Rodando testes para a classe: #{Config.class_being_tested_sufix_path}"

	Runner.call
end


