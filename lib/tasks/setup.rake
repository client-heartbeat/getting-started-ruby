namespace :setup do

  desc 'Setup Application'
  task :all => [:folders] do
  end

  desc 'Setup Folders'
  task :folders do
    puts "Setting up folders"
    puts "  /public" << `mkdir -p public`
    puts "  /db"     << `mkdir -p db`
    puts "  /log"    << `mkdir -p log`
    puts "  /tmp"    << `mkdir -p tmp`
  end

end