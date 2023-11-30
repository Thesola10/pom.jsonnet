autocmd BufWritePost,FileWritePost pom.jsonnet !jsonnet -S pom.jsonnet > pom.xml
