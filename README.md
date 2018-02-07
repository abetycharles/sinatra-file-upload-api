#File Upload API
This API has been developed with the Sinatra framework.
       
##Requirements/Limitations:
    
    * API has two endpoints:
        <server:port>/upload/ AND
        <server:port>/index
     
    * No fancy gems like paperclip or imagemagic or similar are used. 
    * No database or activerecord. 
    * Files are stored on local disk.
    * File dimensions are limited to 350x350 - 5000x5000.
    * File formats are limited to png and jpg
### Author: Charles Abety
    Sr. Ruby on Rails Developer with AWS Experience 
#Usage Instructions
To start the API service, on command line:

    ruby uploader.rb

In another command line window:

To upload file:

	curl -v -T <upload-filename> http://localhost:4567/upload/


To view uploaded files:

	curl -v http://localhost:4567/index
