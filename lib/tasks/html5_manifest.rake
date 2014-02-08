#encoding: utf-8
desc "Create html5 appcache manifest"
task :html5_manifest => :environment do
    File.open("public/offline.appcache", "w") do |f|
        f.write("CACHE MANIFEST\n")
        f.write("# #{Time.now.to_i}\n")
        assets = Dir.glob(File.join(Rails.root, 'public/assets/**/*'))
        assets.each do |file|
            if File.extname(file) != '.gz'
                f.write("assets/#{File.basename(file)}\n")
            end
        end
        # f.write("NETWORK\n")
        # f.write("*\n")
        # f.write("FALLBACK:\n")
        # f.write("...")
    end
end