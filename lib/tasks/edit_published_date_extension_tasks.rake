namespace :radiant do
  namespace :extensions do
    namespace :edit_published_date do
      
      desc "Runs the migration of the Edit Published Date extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          EditPublishedDateExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          EditPublishedDateExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Edit Published Date to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[EditPublishedDateExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(EditPublishedDateExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
