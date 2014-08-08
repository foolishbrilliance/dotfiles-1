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
  # **NOTE:** It's recommended you just use this as a template; if you run these rules on your machine without knowing
  # what they do, you might run into unwanted results!

  download_archive = '/Volumes/Data/Users/joe/DownloadsArchive/'
  desktop_archive = '/Volumes/Data/Users/joe/tmpslow'

  rule 'Trash duplicate downloads' do
    dupes_in('~/Downloads/*').each do |dupes|
      # Keep the dupe with the shortest filename
      trash dupes.sort_by { |p| File.basename(p).length }[1..-1]
    end
  end

  rule 'Mac OS X applications in disk images' do
    trash(dir('~/Downloads/*.dmg'))
  end

  rule 'Mac OS X applications in zip files' do
    found = dir('~/Downloads/*.zip').select { |path|
      zipfile_contents(path).any? { |c| c.match(/\.app$/) }
    }
    trash(found)
  end

  rule 'Handle downloaded software' do
    
    # These can generally be downloaded again very easily if needed... but just in case, give me a few days before trashing them.
    dir('~/Downloads/*.{apk,deb,dmg,exe,pkg,rpm}').each do |p|
      trash(p) if 3.days.since?(accessed_at(p))
    end

    osx_app_extensions = %w(app dmg pkg wdgt mpkg)
    osx_app_patterns = osx_app_extensions.map { |ext| (/\.#{ext}\/$/) }
    
    zips_with_osx_apps_inside = dir('~/Downloads/*.zip').select do |path|
      candidates = zipfile_contents(path)
      candidates.any? { |c| osx_app_patterns.any? { |re| c.match(re) } }
    end
    
    trash(zips_with_osx_apps_inside)
  end

  rule 'Archive downloads' do
    dir('~/Downloads/*').each do |path|
      if 1.week.since?(accessed_at(path))
        move(path, download_archive)
      end
    end
  end

  rule 'Trash download archives' do
    dir(download_archive + "/*").each do |p|
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
    dir(desktop_archive + "/*").each do |p|
      trash(p) if 60.days.since?(accessed_at(p))
    end
  end

end
