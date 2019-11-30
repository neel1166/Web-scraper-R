#Project 1

#Required Package
#install.packages('rvest')
#install.packages('xml2)
#install.packages('stringr')
#install.packages('RCurl')

library('rvest')
library('xml2')
library('stringr')
library('RCurl')

#year <- readline(prompt="Enter the Year(From 2011 to 2019) to scrape all the information of the Journals published in the corresponding year: ")
#year <- as.integer(year)
year <- 2012
 
if(year > 2010 | year < 2020)
  {
    print(paste('Scraper started to retrieve all the information of all the article in year ',year))
    journal_scraping(year)
    print('Scraping successfully Done. All information is stored in "G3_Genes_Genomes_Genetics.txt" file')
    print('All the articles are downloaded to the "article" directory.')
  }

journal_scraping <- function(year){

  my_year= year - 2010
  
  main_link <- paste('https://www.g3journal.org/content', sep = '/', my_year)
  dir.create("articles") #creates a directory to store all the articles of the specific year
  
  #LOOP OVER ENTIRE YEAR
  for(i in 1:12)
  {
    content_url <- paste(main_link, sep='/', i)
    if(url.exists(content_url)){
      webpage = read_html(content_url)
      
      #Get links to every article in the given year
      issue_nodes = html_nodes(webpage, '.highwire-cite-linked-title')
      all_links = html_attr(issue_nodes, "href")
      #print(all_links)
      all_links_length = length(all_links) - 5
      
      for(link in 1:all_links_length)
      {
    
        url_article <- paste('https://www.g3journal.org', sep="", all_links[link])
        url_info <- paste(url_article, sep="", '.article-info')
    
        webpage_info <- read_html(url_info)
        webpage_article <- read_html(url_article)
        
       # Strated extracting all the information
        DOI_temp <- html_text(html_nodes(webpage_article, 'span.highwire-cite-metadata-doi.highwire-cite-metadata'))
        DOI<-sub("https://doi.org/" ,"",DOI_temp[1])
          if(length(DOI)==0){
            DOI<-'NO'
          }
        DOI_link<-gsub("/","_",DOI)
        download.file(DOI_temp[1],paste0("articles/",DOI_link,".html")) # Downloading all the articles to the "articles" directory
        
        iss_title <- html_text(html_nodes(webpage_info, '#page-title'))
        iss_title <- iss_title[1]
          if(length(iss_title)==0){
            iss_title<-'NO'
          }
        
        author_name <- html_text(html_nodes(webpage_info, '.name'))
        author_name <- paste(author_name,collapse = ",")
          if(length(author_name)==0){
            author_name<-'NO'
          }
        
        author_affialtions <- html_text(html_nodes(webpage_info, '.affiliation-list'))
        author_affialtions <- str_replace_all(author_affialtions,'\\*','')
        author_affialtions <- str_replace_all(author_affialtions,'???','')
        author_affialtions <- str_replace_all(author_affialtions,'???','')
          if(length(author_afficaltions)==0){
            author_afficlasscaltions<-'NO'
            }
        
        corres_author_name <- html_text(html_nodes(webpage_info, '.highwire-cite-authors'))
        corres_author_name <- str_replace_all(corres_author_name[1],'View ORCID Profile','')
          if (grepl('and', corres_author_name))
            {
              Corres_author_name <- sub('.*and','', corres_author_name)
    
            }
          if(grepl('and', corres_author_name)==FALSE){
              Corres_author_name <- 'NO'
          }
        
        Corres_author_email <- html_text(html_nodes(webpage_info, '.em-addr'))
        Corres_author_email <- str_replace(Corres_author_email,'\\{at\\}','@')
        if(length(Corres_author_email)==0){
          Corres_author_email<-'NO'
          }
        
        publish_date <- html_text(html_nodes(webpage_article, 'span.highwire-cite-metadata-date.highwire-cite-metadata'))
        publish_date <- as.Date(str_replace_all( publish_date[1], ",", ""),format = "%B %d %Y")
          if(length(publish_date)==0){
            publish_date<-'NO'
            }
        
        abstract <- html_text(html_nodes(webpage_article, '.section.abstract'))
        abstract <- str_replace( abstract, "Abstract", "")
          if(length(abstract)==0){
            abstract<-'NO'
          }
        
        keywords <- html_text(html_nodes(webpage_article, '.kwd'))
        keywords <- paste(keywords,collapse = ",")
          if(length(keywords)==0){
            keywords<-'NO'
          }
        
        full_text <- html_text(html_nodes(webpage_article, '.article.fulltext-view'))
        full_text <- str_replace(full_text, "Abstract", "")
          if(length(full_text)==0){
            full_text<-'NO'
            }
        # Done extrcacting all the information
        
        all_information <- c(DOI, iss_title, author_name, author_afficaltions, corres_author_name, Corres_author_email, publish_date, abstract, keywords, full_text)
        final_output <- matrix(all_information,1,10)# generating the matrix of all information
        write.table(final_output, "G3_Genes_Genomes_Genetics.txt", row.names = FALSE, col.names=FALSE, sep = "\t",append = T) # writing the information to the file
      }
    
    }
  }
}
