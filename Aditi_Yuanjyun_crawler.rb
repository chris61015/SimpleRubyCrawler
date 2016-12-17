#For internet connection
require 'open-uri'
require 'Nokogiri'
require 'mail' 
require 'zip/zip'

def download_image(url, dest)
	if url.include? "http" and url.include? ".jpg" 
		open(url) do |u|
			File.open(dest, 'wb') { |f| f.write(u.read) }
		end
	end
end

def readhtml(inputUrl)
	ary = Array.new 
	serchurl = inputUrl
	Nokogiri::HTML(open(serchurl)).xpath("//img/@src").each do |src|
		ary << src.content
	end	

	return ary
end

def bundle(dir,fileName)
      bundle_filename = fileName
      FileUtils.rm "abc.zip",:force => true
      dir = "./test"
      Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) { |zipfile|
        Dir.foreach(dir) do |item|
          item_path = "#{dir}/#{item}"
          zipfile.add( item,item_path) if File.file? item_path
        end
      }
end

def create_folder(path)
	if !File.exist?(path)
		Dir.mkdir path
	end 	
end

if __FILE__ == $0

	dirPath = "./test"
	fileName = "abc.zip"
	url = "https://imagecomics.com/"

	# The url we are trying to fetch data
	urls = readhtml(url)
	
	#Generate a folder
	create_folder(dirPath)

	#Download pics into the 
	urls.each { |url| download_image(url,dirPath + '/' + url.split('/').last) }
	
	#zip these files 
	bundle(dirPath, fileName)
end

