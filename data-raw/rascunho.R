
balanco <- read.csv(app_sys("data/balanco_coop_cred_2010a2022_4010.csv"))
dicionario <- read.csv(app_sys("data/dicionario.CSV")) |> janitor::clean_names()

dicionario <- dicionario |>
   dplyr::mutate(conta = as.numeric(conta)) |>
   dplyr::filter(!is.na(conta)) |>
   unique()


colnames(balanco) <- stringr::str_remove(colnames(balanco), "^X")

nomes_correspondentes <- dicionario$nome_conta[match(names(balanco), dicionario$conta)]

# Renomear as colunas automaticamente
colnames(balanco) <- ifelse(!is.na(nomes_correspondentes),
                            paste(names(balanco), nomes_correspondentes, sep = "_"),
                            names(balanco))



cnpj_2022 <- balanco |> dplyr::filter(ano == "202212") |> dplyr::select(cnpj)
balanco <- balanco |> dplyr::filter(cnpj %in% cnpj_2022$cnpj)

write.csv(balanco, "inst/data/balanco_coop_cred_2010a2022_4010.csv", row.names = FALSE)



balanco |>
   dplyr::filter(cnpj == 1060307) |>
   dplyr::mutate(ano = as.Date(sprintf("%s-%s-01", substr(ano, 1, 4), substr(ano, 5, 6)))) |>
   echarts4r::e_chart(x = ano) |>
   echarts4r::e_line(serie = X11000006_DISPONIBILIDADES)
