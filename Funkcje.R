library(httr)
dat = read.table("./passwords.txt", sep = ",", header = TRUE)
key = key = dat[,1]
url = "https://api.themoviedb.org/3/authentication"

response = VERB("GET", url, add_headers('Authorization' = key), content_type("application/octet-stream"), accept("application/json"))

content(response, "text")