require 'fileutils'

class JournalEntry
  attr_accessor :fqfilename, :filename, :filetype, :year, :month, :month_abv, :day, :dir, :entry_exists, :menu_entries

  @@ROOT = "/Users/aaron/photojournal"
  @@CONTENT = "#{@@ROOT}/content"

  def initialize(options={})
    @fqfilename = options[:fqfilename]
    @year = getYear
    @month = getMonth
    @month_abv = getMonthAbv
    @day = getDay
    @filetype = getFiletype
    @dir = "#{@@CONTENT}/pages/#{@year}#{@month}"
    @filename = @fqfilename.split("/").last
    copyFileToAttachments
    @menu_entries = getMenuEntries
    createDir
    createIndexfile unless File.exists?("#{self.dir}/index.haml")
    @entry_exists = entryExist?
    insertEntry(@fqfilename, "#{self.dir}/#{self.filename}.haml", "#{@month}")    
    addIndexEntry
  end

  def getYear
    File.mtime(self.fqfilename).strftime("%Y")
  end

  def getMonth
    File.mtime(self.fqfilename).strftime("%-m")
  end

  def getMonthAbv
    File.mtime(self.fqfilename).strftime("%b")
  end

  def getDay
    File.mtime(self.fqfilename).strftime("%-d")
  end

  def getFiletype
    ext = self.fqfilename.split(".").last

    case ext.downcase
    when /jpg|png/
      return "image"
    when /mov/
      return "video"
    end
  end

  def copyFileToAttachments
    puts "--- trying to copy files #{@@CONTENT}/attachments/#{self.filename}"
    # unless File.exists?("#{@@CONTENT}/attachments/#{self.filename}")
      puts "----- file #{@@CONTENT}/attachments/#{self.filename} does not exist!!!"
      puts "----- copying from #{self.fqfilename}"
      FileUtils.copy_file(self.fqfilename, "#{@@CONTENT}/attachments/#{self.filename}") 
    # end
  end

  def createDir
    puts "created dir #{dir}"
    Dir.mkdir(self.dir) unless File.directory?(self.dir)
  end

  def createIndexfile
    indexTemplate = <<EOS
%h1 #{@year} #{@month}
EOS
    tempfile=File.open("#{self.dir}/index.haml", 'w')
    tempfile<<indexTemplate
    tempfile.close    
  end

  def indexExist?
    open("#{@@CONTENT}/menu.txt", 'r').each { |l| entry = l if l.include? "#{self.year}#{self.month.to_i}" }
    false
  end

  def getMenuEntries
    results = []
    File.open("#{@@CONTENT}/menu.txt", 'r').each { |line| results.push(line) }
    return results
  end

  def addIndexEntry
    indexEntryToAdd = "#{@year}#{@month}"
    menu_entries_dates_only = menu_entries.delete_if {|x| x =~ /(video|images)/ }
    menu_file = File.open("#{@@CONTENT}/menu.txt", "w")

    if self.menu_entries.include?(indexEntryToAdd)
      puts "skipping entry, #{indexEntryToAdd} already exists"
    else
      puts "need to put an entry in !!!"  
      # read index file into array
      # add index entry
      menu_entries_dates_only.push(indexEntryToAdd + "\n")
      menu_entries_dates_only.sort.uniq
      puts "--- new menu entries #{menu_entries_dates_only}"
      # if menu_entries_dates_only.length == 0
      #   puts "no date entries exist"
      #   puts "adding date entry now"
      #   menu_file << indexEntryToAdd
      #   menu_file << "\n"
      # else
      #   puts "adding menu entry to array"
      #   @menu_entries.push(indexEntryToAdd)
      #   puts "new menu entries #{@menu_entries.sort.reverse}"
      # end

    end

    # add video and images back in
    menu_file << "images\n"
    menu_file << "videos\n"

    # loop through the dates and add them to the menu file
    menu_entries_dates_only.sort.uniq.each do |entry|
      menu_file << entry
    end

    menu_file.close    
  end

  def entryExist?

    open("#{self.dir}/index.haml", 'r').each { |l| entry = l if l.include? "h2" }

    # File.open( "#{self.dir}/index.haml" ) do |io|
    #   io.each {|line| line.chomp!; puts "#{line} checked for h2" ; return true if line.include? "h1"}
    # end
  false
  end

  def template(selection)
    case selection
    when "video"
      results = <<EOS
Date: #{@day} #{@month_abv}, #{@year}
Categories: videos, #{@year}#{@month.to_i}

%h2 #{@year} #{@month} #{@day}

%div
  %a(href="/attachments/#{@filename}")
    #{@filename}
%div
  %video(controls src="/attachments/#{@filename}" width="320")
    Your user agent does not support the HTML5 Video element.

EOS
    when "image"
      results = <<EOS
Date: #{@day} #{@month_abv}, #{@year}
Categories: images, #{@year}#{@month.to_i}

%h2 #{@year} #{@month} #{@day}

%div
  %a(href="/attachments/#{@filename}")
    %img(src="/attachments/#{@filename}")

EOS
    end
    return results
  end

  def insertEntry(fqfilename, target, monthstr)
    targetfile = File.open(target, 'w')
    targetfile << template(@filetype)
    targetfile.close    
  end
end

process_files = ["/Users/aaron/Pictures/iphone1/IMG_0057.JPG"]
           
process_files.each do |f|
  x = JournalEntry.new(:fqfilename => f)
  puts x.inspect
end

ARGV.each do |f|
  JournalEntry.new(:fqfilename => f)
end