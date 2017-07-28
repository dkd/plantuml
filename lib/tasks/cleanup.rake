require 'rake/clean'

namespace :redmine do
  namespace :plantuml do
    desc 'Cleanup plantuml files'
    task cleanup: :environment do
      files = CLOBBER.include(File.join(Rails.root, 'files', 'plantuml_*.*'))
      FileUtils.rm(files)
    end
  end
end
