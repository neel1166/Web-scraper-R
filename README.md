# Web-scraper-R
Parameters: The year between 2011-2019 to retrieve articles.

Description:	Scrapes all articles from the archives of g3journal.org published on the specified year.  All information of each article is written to a text file as comma separated values named G3_Genes_Genomes_Genetics.txt. First, the year that is passed is concatenated into the link:https://www.g3journal.org/content. This link holds the links to all articles of the specified year and is organized by month. All of the links to the articles are then searched for specific information such as title, publisher, etc. The specific information is found by searching the HTML nodes for specific identifiers. For example, the title of the article can be found in the HTML node that has the identifier. All information is extracted in a similar way and is stored in a text file in the end.

File:	read.r

Description:	Reads the contents of the generated file G3_Genes_Genomes_Genetics.txt.
