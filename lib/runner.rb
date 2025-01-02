require_relative './../config'
require_relative './ia_prompts/create_test'
require_relative './ia_prompts/run_fix_test_in_loop'
require_relative './ia_prompts/find_related_files'

module Runner
	class << self
		def call
			unless File.exist?(Config.class_being_tested_path)
			  puts "\e[31mArquivo não encontrado\e[0m"
				return
			end

			if !File.exist?(Config::RELATED_FILES_DB_PATH) || File.read(Config::RELATED_FILES_DB_PATH).empty?
				IaPrompts::FindRelatedFiles.call
			end

			IaPrompts::CreateTest.call unless File.exist?(Config::file_test_path)

			IaPrompts::RunFixTestInLoop.call
		end
	end
end


Runner.call
