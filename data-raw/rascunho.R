
balanco <- read.csv(app_sys("data/balanco_coop_cred_2010a2022_4010.csv"))


balanco |>
   dplyr::filter(razao_social == "BOM CREDI") |>
   dplyr::mutate(ano = as.Date(sprintf("%s-%s-01", substr(ano, 1, 4), substr(ano, 5, 6)))) |>
   echarts4r::e_chart(x = ano) |>
   echarts4r::e_line(serie = X10000007)
