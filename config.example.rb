# frozen_string_literal: true

module Config
	# Defina a chave da sua API OpenAI
	API_KEY = 'XXXXX'

	# O endpoint da API
	URL = 'https://api.openai.com/v1/chat/completions'

	MODEL = 'gpt-4o'

	OUTPUT_FAILURE_TESTS_PATH = '/home/username/Documents/ruby-cover-agent/db/output_failure_tests.txt'

	PROJECT_ROOT_PATH = '/home/username/Documents/ruby-workspace/teste/'

	PROJECT_FILES_PATH = "/home/username/Documents/ruby-cover-agent/db/project_files.txt"

	RELATED_FILES_DB_PATH = '/home/username/Documents/ruby-cover-agent/db/related_files.txt'

	SUCCESS_FILE_TESTS_PATH = '/home/username/Documents/ruby-cover-agent/db/success_file_tests.txt'

	@@class_being_tested_sufix_path = 'app/models/user.rb'

	class << self
		def class_being_tested_sufix_path
			@@class_being_tested_sufix_path
		end

		def class_being_tested_sufix_path=(value)
			@@class_being_tested_sufix_path = value
		end

		def file_test_sufix_path
			class_being_tested_sufix_path.sub("app", "spec").sub(".rb", "_spec.rb").sub("lib", "spec/lib")
		end

		def class_being_tested_path
			"#{PROJECT_ROOT_PATH + class_being_tested_sufix_path}"
		end

		def file_test_path
			"#{PROJECT_ROOT_PATH + file_test_sufix_path}"
		end

		def related_files_sufix_path
			if File.exists?(RELATED_FILES_DB_PATH)
				related_files_text = File.read(RELATED_FILES_DB_PATH).split("\n")
			else
				[]
			end
		end

		def related_files
			related_files_sufix_path.filter_map do |file|
				unless File.exist?("#{PROJECT_ROOT_PATH + file}")
					puts "\e[31mArquivo não encontrado: #{file}\e[0m"
					next
				end

				File.read("#{PROJECT_ROOT_PATH + file}")
			end
		end
	end
end
