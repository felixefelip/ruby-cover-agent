require_relative '../../config'
require_relative './fix_test'

module IaPrompts
	module RunFixTestInLoop
		class << self
			def call
				10.times do
					success = false

					Dir.chdir(Config::PROJECT_ROOT_PATH) do
						output = `bundle exec rspec #{Config.file_test_path}`
						success = $?.success?

						puts output

						if success
							File.open(Config::OUTPUT_FAILURE_TESTS_PATH, "w") do |file|
								file.puts ""
							end
						else
							File.open(Config::OUTPUT_FAILURE_TESTS_PATH, "w") do |file|
								file.puts output
							end
						end
					end

					if success && File.read(Config::OUTPUT_FAILURE_TESTS_PATH).empty?
						File.delete(Config::RELATED_FILES_DB_PATH)

						puts "\e[32m\n\nTodos os testes passaram! 🎉\n\n\e[0m"

						File.open(Config::SUCCESS_FILE_TESTS_PATH, "a") do |file|
							file.puts "#{Config.class_being_tested_path}"
						end

						break
					end

					puts "\e[33m\n\nAlguns testes falharam. Corrigindo com o ChatGPT...\n\n\e[0m"

					IAPrompts::FixTest.call
				end
			end
		end
	end
end
