# Sample Maid rules file -- some ideas to get you started.
#

#
#     maid clean -n
#
# **NOTE:** It's recommended you just use this as a template; if you run these rules on your machine without knowing
# what they do, you might run into unwanted results!
#
# Don't forget, it's just Ruby!  You can define custom methods and use them below:
# 
#     def magic(*)
#       # ...
#     end
# 
# If you come up with some cool tools of your own, please send me a pull request on GitHub!  Also, please consider sharing your rules with others via [the wiki](https://github.com/benjaminoakes/maid/wiki).
#
# For more help on Maid:
#
# * Run `maid help`
# * Read the README, tutorial, and documentation at https://github.com/benjaminoakes/maid#maid
# * Ask me a question over email (hello@benjaminoakes.com) or Twitter (@benjaminoakes)
# * Check out how others are using Maid in [the Maid wiki](https://github.com/benjaminoakes/maid/wiki)

Maid.rules do

  # My custom folders
  download_archive = '/Volumes/Data/Users/joe/DownloadsArchive/'
  desktop_archive = '/Volumes/Data/Users/joe/tmpslow/'

  rule 'Clean Downloads folder' do
    
    # These can generally be downloaded again very easily if needed... but just in case, give me a few days before trashing them.
    dir('~/Downloads/*.{apk,deb,dmg,exe,pkg,rpm,app}').each do |p|
      trash(p) if 7.days.since?(accessed_at(p))
    end

    # Trash .zips with OSX apps inside
    osx_app_extensions = %w(app dmg pkg wdgt mpkg)
    osx_app_patterns = osx_app_extensions.map { |ext| (/\.#{ext}\/$/) }
    zips_with_osx_apps_inside = dir('~/Downloads/*.zip').select do |path|
      candidates = zipfile_contents(path)
      candidates.any? { |c| osx_app_patterns.any? { |re| c.match(re) } }
    end
    trash(zips_with_osx_apps_inside)

    # Trash dupes
    trash(verbose_dupes_in('~/Downloads/*'))

    # Archive old downloads and trash original
    dir('~/Downloads/*').each do |p|
      if 2.week.since?(created_at(p))
        sync(p, download_archive+File.basename(p))
        trash(p)
      end
    end
  end

  rule 'Trash download archives' do
    dir(download_archive + '*').each do |p|
      trash(p) if 60.days.since?(accessed_at(p))
    end
  end

  rule 'Archive desktop' do
    dir('~/Desktop/*').each do |path|
      if 7.day.since?(accessed_at(path))
        move(path, desktop_archive)
      end
    end
  end

  rule 'Trash desktop archives' do
    dir(desktop_archive + '*').each do |p|
      trash(p) if 60.days.since?(accessed_at(p))
    end
  end
end
