#For internet connection
require 'open-uri'
require 'Nokogiri'
require 'mail' 
require 'zip/zip'

def download_image(url, dest)
	if url.include? "http"
		open(url) do |u|
			File.open(dest, 'wb') { |f| f.write(u.read) }
		end
	end
end


# urls = [
#     'http://petsfans.com/wp-content/uploads/2014/11/edfsaf.jpg',
#     'http://dailynewsdig.com/wp-content/uploads/2012/06/funny-cats.jpg',
#     'https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg'
# ]


def readhtml(inputUrl)
	ary = Array.new 
	serchurl = inputUrl
	Nokogiri::HTML(open(serchurl)).xpath("//img/@src").each do |src|
		ary << src.content
	end	

	return ary
end

def send_email()
	mail = Mail.new do
	  from     'chris61015@gmail.com'
	  to       'chris61015@gmail.com'
	  subject  'Here is the image you wanted'
	  body     'no body'
	  add_file :filename => 'abc.zip', :content => File.read('./abc.zip')
	end

	mail.delivery_method :sendmail

	mail.deliver
end


def bundle()
      bundle_filename = "abc.zip"
      FileUtils.rm "abc.zip",:force => true
      dir = "./test"
      Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) { |zipfile|
        Dir.foreach(dir) do |item|
          item_path = "#{dir}/#{item}"
          zipfile.add( item,item_path) if File.file?item_path
        end
      }
end

if __FILE__ == $0
	#The url we are trying to fetch data
	# urls = readhtml("https://imagecomics.com/")
	
	#Generate a folder
	# Dir.mkdir 'test'

	#Download pics into the 
	# urls.each { |url| download_image(url,"./test/" + url.split('/').last) }
	
	#zip these files 
	# bundle()
	send_email()
end

