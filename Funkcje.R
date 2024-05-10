library(httr)
library(jsonlite)
library(data.table)
library(dplyr)
dat = read.table("./passwords.txt", sep = ",", header = TRUE)
key = dat[,1]
url = "https://api.themoviedb.org/3/authentication"

response = VERB("GET", url, add_headers('Authorization' = key), content_type("application/octet-stream"), accept("application/json"))

content(response, "text")


url <- "https://api.themoviedb.org/3/discover/movie"
final_dt <- data.table(matrix(ncol = 10))
                       
colnames(final_dt)=c("adult","genre_ids","id","original_language","original_title","popularity", "release_date","title", "vote_average", "vote_count")
for (number in 1:30) {
queryString <- list(
  include_adult = "false",
  include_video = "false",
  language = "en-US",
  page = number,
  sort_by = "popularity.desc"
)

response <- VERB("GET", url, query = queryString, add_headers('Authorization' = key), content_type("application/octet-stream"), accept("application/json"))

cos = content(response, "text")
api_response = cos                          
parsed_data = fromJSON(api_response)  
parsed_data_df = parsed_data$results
parsed_data_dt = as.data.table(parsed_data_df)
colnames(parsed_data_dt)
parsed_data_dt = parsed_data_dt[, .(adult, genre_ids, id, original_language,
                                    original_title, popularity, release_date,
                                    title, vote_average, vote_count)]
final_dt = rbindlist(list(final_dt,parsed_data_dt))

}
View(final_dt)
final_dt = final_dt[-1,]
saveRDS(final_dt,"dane.rds")
readRDS("dane.rds")

