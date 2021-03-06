module Overcommit::Hook::PreCommit
  # Runs `coffeelint` against any modified CoffeeScript files.
  class CoffeeLint < Base
    def run
      unless in_path?('coffeelint')
        return :warn, 'Run `npm install -g coffeelint`'
      end

      result = command("coffeelint --quiet #{applicable_files.join(' ')}")
      return :good if result.success?
      return :bad, result.stdout
    end
  end
end
