namespace :db do
  desc "Backup the database"
  task backup: :environment do
    require "fileutils"

    backup_path = "db/backup/main_backup.sqlite3"

    # Copy the database to create a backup
    FileUtils.cp("db/main.sqlite3", backup_path)
    puts "Database backed up to #{backup_path}"
  end
end
